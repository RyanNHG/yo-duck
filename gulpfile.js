const gulp = require('gulp')
const del = require('del')
const ts = require('gulp-typescript')
const elm = require('gulp-elm')
const sass = require('gulp-sass')
const series = require('run-sequence')

const tsProject = ts.createProject('tsconfig.json')
const paths = {
  del: {
    folders: [ 'public' ]
  },
  html: {
    src: 'src/web/**/*.html',
    dest: 'public/web'
  },
  elm: {
    src: 'src/web/app/**/*.elm',
    out: 'app.js',
    dest: 'public/web'
  },
  css: {
    src: 'src/web/styles/**/*.scss',
    dest: 'public/web'
  },
  electron: {
    src: 'src/**/*.ts',
    dest: 'public'
  }
}

// HTML
gulp.task('html', () =>
  gulp.src(paths.html.src)
    .pipe(gulp.dest(paths.html.dest))
)

gulp.task('html:watch', ['html'], () =>
  gulp.watch(paths.html.src, ['html'])
)

// ELM
gulp.task('elm:init', elm.init)

gulp.task('elm', ['elm:init'], () =>
  gulp.src(paths.elm.src)
    .pipe(elm.bundle(paths.elm.out))
    .on('error', () => {})
    .pipe(gulp.dest(paths.elm.dest))
)

gulp.task('elm:watch', ['elm'], () =>
  gulp.watch(paths.elm.src, ['elm'])
)

// CSS
gulp.task('css', () =>
  gulp.src(paths.css.src)
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest(paths.css.dest))
)

gulp.task('css:watch', ['css'], () =>
  gulp.watch(paths.css.src, ['css'])
)

// ELECTRON
gulp.task('electron', () => gulp
  .src(paths.electron.src)
  .pipe(tsProject())
  .js
  .pipe(gulp.dest(paths.electron.dest))
)

gulp.task('electron:watch', ['electron'], () => {
  gulp.watch(paths.electron.src, ['electron'])
})

// DEFAULT COMMANDS
gulp.task('clean', () => del(paths.del.folders))
gulp.task('build', ['elm', 'html', 'css', 'electron'])
gulp.task('watch', ['elm:watch', 'html:watch', 'css:watch', 'electron:watch'])

gulp.task('dev', (done) => series('clean', 'watch', done))
gulp.task('default', (done) => series('clean', 'build', done))