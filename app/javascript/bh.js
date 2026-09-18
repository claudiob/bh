// Everything a page built on Bootstrap 6 runs, in one module: Turbo with the cable element
// turbo-rails signs its streams for, Bootstrap itself, and a Stimulus application with every
// controller this gem's markup names. Built by esbuild into /js/bh.js.
import '@hotwired/turbo-rails'
import 'bootstrap'
import { Application } from '@hotwired/stimulus'
import confirm from './bh/confirm.js'
import BookmarkController from './bh/bookmark_controller.js'
import ClearController from './bh/clear_controller.js'
import ComboboxController from './bh/combobox_controller.js'
import DensityController from './bh/density_controller.js'
import DeselectController from './bh/deselect_controller.js'
import LimitController from './bh/limit_controller.js'
import MapController from './bh/map_controller.js'
import OtpController from './bh/otp_controller.js'
import PhoneController from './bh/phone_controller.js'
import PlaceholderController from './bh/placeholder_controller.js'
import RelativeTimeController from './bh/relative_time_controller.js'
import RequireController from './bh/require_controller.js'
import RevealController from './bh/reveal_controller.js'
import SchemeController from './bh/scheme_controller.js'
import SearchController from './bh/search_controller.js'
import ShortcutsController from './bh/shortcuts_controller.js'
import SortableController from './bh/sortable_controller.js'
import ThreadController from './bh/thread_controller.js'
import TimezoneController from './bh/timezone_controller.js'
import ToastController from './bh/toast_controller.js'
import TooltipController from './bh/tooltip_controller.js'
import WrittenController from './bh/written_controller.js'

// Guarded: a module runs once, but a host that also loads this file from its own
// layout on a Turbo visit would otherwise connect every controller a second time.
if (!window.Stimulus) {
  window.Stimulus = Application.start()
  window.Stimulus.register('bookmark', BookmarkController)
  window.Stimulus.register('clear', ClearController)
  window.Stimulus.register('combobox', ComboboxController)
  window.Stimulus.register('density', DensityController)
  window.Stimulus.register('deselect', DeselectController)
  window.Stimulus.register('limit', LimitController)
  window.Stimulus.register('map', MapController)
  window.Stimulus.register('otp', OtpController)
  window.Stimulus.register('phone', PhoneController)
  window.Stimulus.register('placeholder', PlaceholderController)
  window.Stimulus.register('relative-time', RelativeTimeController)
  window.Stimulus.register('require', RequireController)
  window.Stimulus.register('reveal', RevealController)
  window.Stimulus.register('scheme', SchemeController)
  window.Stimulus.register('search', SearchController)
  window.Stimulus.register('shortcuts', ShortcutsController)
  window.Stimulus.register('sortable', SortableController)
  window.Stimulus.register('thread', ThreadController)
  window.Stimulus.register('timezone', TimezoneController)
  window.Stimulus.register('toast', ToastController)
  window.Stimulus.register('tooltip', TooltipController)
  window.Stimulus.register('written', WrittenController)

  // The browser's confirm() becomes a Bootstrap dialog the module draws on the first ask.
  window.Turbo.config.forms.confirm = confirm
}
