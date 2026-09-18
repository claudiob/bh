// Builds the stylesheet and the script into public/bh/, under the prefix the engine serves them
// at, which is also what the gem ships. Every URL inside is relative to the file holding it,
// so one build answers from the gem and from a CDN carrying the package alike.
import { build } from 'esbuild'
import { cpSync, mkdirSync } from 'node:fs'

await build({
  entryPoints: ['app/javascript/bh.js', 'app/stylesheets/bh.css'],
  bundle: true,
  minify: true,
  format: 'esm',
  outdir: 'public/bh',
  entryNames: '[ext]/[name]',
  alias: { bootstrap: './vendor/bootstrap.bundle.min.js' },
  logLevel: 'info',
})

// The nine palettes are not bundled: a page links one at a time and swaps it for another,
// which is the whole point of them, so they are copied beside the stylesheet as they are.
mkdirSync('public/bh/theme', { recursive: true })
cpSync('app/stylesheets/theme', 'public/bh/theme', { recursive: true })
