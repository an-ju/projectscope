<template>
    <p v-if="null_data()"> No Data </p>
    <div v-else-if="is_error()" class="dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="text-red dropdown-toggle">
            Error
        </div>
        <ul class="dropdown-menu">
            <li class="px-3 py-3"> {{ this.error_message }}</li>
        </ul>
    </div>
   <component v-else :is="this.metric_name" :image="image" :metric="metric"></component>
</template>

<script>
    import CodeClimate from 'metrics/code_climate.vue'
    import TestCoverage from 'metrics/test_coverage.vue'
    import PullRequests from 'metrics/pull_requests.vue'
    import TravisCI from 'metrics/travis_ci.vue'
    import GithubFlow from 'metrics/github_flow'
    import PointDistribution from 'metrics/point_distribution'
    import StoryOverall from 'metrics/story_overall'
    import HerokuStatus from 'metrics/heroku_status'
    import GithubUse from 'metrics/github_use'
    import GithubBranch from 'metrics/github_branch'
    import TrackerActivities from 'metrics/tracker_activities'
    import CycleTime from 'metrics/cycle_time'

    export default {
        name: "metric-table-project-metric",
        props: {
            d: String,
            s: String,
            metric_name: String
        },
        computed: {
            image: function () {
                return this.metric.image
            },
            metric: function() {
                return JSON.parse(this.d)
            },
            error_message: function() {
                return this.image.message
            }
        },
        components: {
            'code_climate': CodeClimate,
            'test_coverage': TestCoverage,
            'pull_requests': PullRequests,
            'travis_ci': TravisCI,
            'github_flow': GithubFlow,
            'point_distribution': PointDistribution,
            'story_overall': StoryOverall,
            'heroku_status': HerokuStatus,
            'github_use': GithubUse,
            'github_branch': GithubBranch,
            'tracker_activities': TrackerActivities,
            'cycle_time': CycleTime
        },
        methods: {
            null_data() {
                return this.d === 'null'
            },
            is_error() {
                return this.image.chartType === 'error_message'
            }
        }
    }
</script>

<style scoped>

</style>