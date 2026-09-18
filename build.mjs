// Builds the stylesheet and the script into public/bh/, under the prefix the engine serves them
// at, which is also what the gem ships. Every URL inside is relative to the file holding it,
// so one build answers from the gem and from a CDN carrying the package alike.
import { build } from 'esbuild'

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
