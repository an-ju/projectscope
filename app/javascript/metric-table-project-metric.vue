<template>
    <p v-if="null_data"> No Data </p>
   <component v-else :is="this.metric_name" :d="this.d" :s="this.s" :i="image"></component>
</template>

<script>
    import CodeClimate from 'metrics/code_climate.vue'
    import TestCoverage from 'metrics/test_coverage.vue'
    import PullRequests from 'metrics/pull_requests.vue'
    import TravisCI from 'metrics/travis_ci.vue'
    import GithubFiles from 'metrics/github_files.vue'
    import CommitMessage from 'metrics/commit_message.vue'
    import GithubFlow from 'metrics/github_flow'
    import PointDistribution from 'metrics/point_distribution'
    import PointEstimation from 'metrics/point_estimation'
    import SmartStory from 'metrics/smart_story'
    import StoryOverall from 'metrics/story_overall'
    import HerokuStatus from 'metrics/heroku_status'

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
            'github_files': GithubFiles,
            'commit_message': CommitMessage,
            'github_flow': GithubFlow,
            'point_distribution': PointDistribution,
            'point_estimation': PointEstimation,
            'smart_story': SmartStory,
            'story_overall': StoryOverall,
            'heroku_status': HerokuStatus
        }
    }
</script>

<style scoped>

</style>