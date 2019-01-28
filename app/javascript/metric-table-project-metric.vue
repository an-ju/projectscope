<template>
    <p v-if="null_data"> No Data </p>
   <component v-else :is="this.metric_name" :d="this.d" :s="this.s" :image="image"></component>
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

    export default {
        name: "metric-table-project-metric",
        props: {
            d: String,
            s: String,
            metric_name: String
        },
        computed: {
            null_data: function () {
                return this.d === 'null'
            },
            image: function () {
                return JSON.parse(this.d)['image']
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
            'tracker_activities': TrackerActivities
        }
    }
</script>

<style scoped>

</style>