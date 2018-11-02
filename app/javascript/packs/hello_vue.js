/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you have styles in your component)
// to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

// import Vue from 'vue'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const el = document.body.appendChild(document.createElement('hello'))
//   const app = new Vue({
//     el,
//     render: h => h(App)
//   })
//
//   console.log(app)
// })


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>


// import Vue from 'vue/dist/vue.esm'
// import App from '../app.vue'
//
// document.addEventListener('DOMContentLoaded', () => {
//   const app = new Vue({
//     el: '#hello',
//     data: {
//       message: "Can you say hello?"
//     },
//     components: { App }
//   })
// })
//
//
//
// If the using turbolinks, install 'vue-turbolinks':
//
// yarn add 'vue-turbolinks'
//
// Then uncomment the code block below:
//
import TurbolinksAdapter from 'vue-turbolinks'
import Vue from 'vue/dist/vue.esm'
import VTooltip from 'v-tooltip'
import MetricTable from '../metric-table.vue'
import CodeClimate from '../metrics/code_climate.vue'
import TestCoverage from '../metrics/test_coverage.vue'
import PullRequests from '../metrics/pull_requests.vue'
import TravisCI from '../metrics/travis_ci.vue'
import GithubFiles from '../metrics/github_files.vue'
import CommitMessage from '../metrics/commit_message.vue'

Vue.use(TurbolinksAdapter)
Vue.use(VTooltip)

document.addEventListener('turbolinks:load', () => {
    const app = new Vue({
        el: '#metric_table',
        components: {
            'metric-table': MetricTable,
            'code_climate': CodeClimate,
            'test_coverage': TestCoverage,
            'pull_requests': PullRequests,
            'travis_ci': TravisCI,
            'github_files': GithubFiles,
            'commit_message': CommitMessage,
        }
    })
})
