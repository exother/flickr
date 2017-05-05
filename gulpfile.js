var gulp = require('gulp');
var gutil = require('gulp-util');
var uglify = require('gulp-uglify');
var coffee = require('gulp-coffee');
var ngClassify = require('gulp-ng-classify');
var ngAnnotate = require('gulp-ng-annotate');
var concat = require('gulp-concat');
var strip_log = require('gulp-strip-debug');
var wrap = require('gulp-wrap');
var filter = require('gulp-filter');
var rename = require('gulp-rename');
var flatten = require('gulp-flatten');
var mainBowerFiles = require('main-bower-files');

var dest = './assets'

var jobs = [];

// BOWER DEPENDENCIES

gulp.task('bower-js', function() {

    gulp.src(mainBowerFiles())
        .pipe(filter('**/*.js'))
        .pipe(uglify())
        .pipe(gulp.dest(dest + '/javascript'));

});

jobs.push('bower-js');

gulp.task('bower-css', function() {

    gulp.src(mainBowerFiles())
        .pipe(filter('**/*.css'))
        .pipe(uglify())
        .pipe(gulp.dest(dest + '/css'));

});

jobs.push('bower-css');

// ANGULAR COMPILATION
var paths = {};
var tasks = [
    {
        name: 'app',
        dependency: ['default']
    },
    {
        name: 'flickr',
        dependency: ['flickr', 'shared']
    }

];

var t, i, j, p, f;

get_task_function_for = function(task) {
    f = function(done){
        gulp.src(paths[task])
            .pipe(ngClassify())
            .pipe(coffee({bare: true}).on('error', gutil.log))
            .pipe(ngAnnotate())
            .pipe(concat(task+'.js'))
            .pipe(strip_log())
            .pipe(uglify())
            .pipe(wrap('(function(){\n<%= contents %>\n})();'))
            .pipe(gulp.dest(dest + '/javascript/angular/'))
            .on('end', done)
    };
    return f
};

for(i=0;i<tasks.length;++i){
    t = tasks[i].name;
    jobs.push(t);
    paths[t] = [];
    for (j=0;j<tasks[i].dependency.length;++j){
        p = tasks[i].dependency[j];
        paths[t].push('./angular/'+p+'/**/*.coffee');
    }
    gulp.task(t, get_task_function_for(t));
}

gulp.task('default', jobs);

