import { Controller } from '@hotwired/stimulus'
import { load } from './map/loader.js'

// This page of a table on a Google map. A row keeping a place ID has its area filled in
// on the boundary layer its model named — a county, a ZIP — or, where the model named
// none, a pin at the place; a row keeping coordinates is a pin there and then, with
// nothing to look up. The key and the map are the host's, read from its credentials; the
// rows are the page's, and the map is fitted round whatever it drew.
//
// A row may carry where it leads and what it is called: a point as `[lat, lng, href, title]`,
// a place as `[id, href, title]`, where a bare place ID or a bare `[lat, lng]` leads nowhere.
// A pin or an area with somewhere to lead is clicked through to it, the way the row's own
// link in the table is.
export default class extends Controller {
  static values = { key: String, id: String, boundary: String, places: Array, points: Array }

  async connect() {
    load(this.keyValue)
    const { Map } = await google.maps.importLibrary('maps')
    const { LatLngBounds } = await google.maps.importLibrary('core')

    // A picture rather than a control: the table's search, sort and pages are how a
    // reader moves through the rows, and the map only shows where this page's are.
    const map = new Map(this.element, {
      mapId: this.idValue, gestureHandling: 'none', zoomControl: false,
      disableDefaultUI: true, keyboardShortcuts: false
    })
    const bounds = new LatLngBounds()

    await Promise.all([this.place(map, bounds), this.point(map, bounds)])
    if (!bounds.isEmpty()) map.fitBounds(bounds, 10)
  }

  // The rows named by a place ID: areas on the boundary layer, or pins where there is none.
  async place(map, bounds) {
    if (this.placesValue.length === 0) return
    const { Place } = await google.maps.importLibrary('places')
    const rows = this.placesValue.map(row => [].concat(row))
    const places = rows.map(([id, href, title]) => ({ place: new Place({ id }), href, title }))

    if (this.hasBoundaryValue) return this.fill(map, bounds, places)
    return this.pin(map, bounds, places)
  }

  // The layer styles every boundary Google knows at that level, and a function saying
  // which of them are ours is what fills them in. The bounds are the places' viewports.
  // An area with somewhere to lead is followed there when clicked.
  async fill(map, bounds, places) {
    const hrefs = new Map(places.map(({ place, href }) => [place.id, href]))
    const layer = map.getFeatureLayer(this.boundaryValue)
    layer.style = ({ feature }) => {
      if (hrefs.has(feature.placeId)) return FILLED
    }
    layer.addListener('click', ({ features }) => {
      const href = features.map(feature => hrefs.get(feature.placeId)).find(Boolean)
      if (href) visit(href)
    })

    await Promise.all(places.map(({ place }) =>
      fetched(place, 'viewport').then(() => { if (place.viewport) bounds.union(place.viewport) })
    ))
  }

  async pin(map, bounds, places) {
    const drop = await this.dropper(map, bounds)

    await Promise.all(places.map(({ place, href, title }) =>
      fetched(place, 'location').then(() => { if (place.location) drop(place.location, href, title) })
    ))
  }

  // The rows named by coordinates, which are pins without a lookup.
  async point(map, bounds) {
    if (this.pointsValue.length === 0) return
    const drop = await this.dropper(map, bounds)

    for (const [lat, lng, href, title] of this.pointsValue) drop({ lat, lng }, href, title)
  }

  // One marker at a position, and the bounds widened to hold it. A marker with somewhere to
  // lead is clickable, names what it leads to on hover, and is followed there when clicked.
  async dropper(map, bounds) {
    const { AdvancedMarkerElement } = await google.maps.importLibrary('marker')

    return (position, href, title) => {
      const marker = new AdvancedMarkerElement({ map, position, title, gmpClickable: Boolean(href) })
      if (href) marker.addEventListener('gmp-click', () => visit(href))
      bounds.extend(position)
    }
  }
}

// Through Turbo where the page has it, so the table's frame and scroll behave as a click on
// the row's own link would; a plain navigation otherwise.
function visit(href) {
  if (window.Turbo) window.Turbo.visit(href)
  else window.location.assign(href)
}

// A place that cannot be fetched — an ID Google no longer knows — is left off the map
// rather than taking the rest of the page's rows with it.
function fetched(place, field) {
  return place.fetchFields({ fields: [field] }).catch(console.error)
}

const FILLED = {
  strokeColor: '#2D85FF', strokeOpacity: 1.0, strokeWeight: 3.0,
  fillColor: '#2D85FF', fillOpacity: 0.5
}
