<template>
    <div class="dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="text-white float-left w-full rounded-full" :class="bg_color">{{ num_issues }} issues </div>
        <ul class="dropdown-menu">
            <div v-for="s in story_issues">
                <li class="dropdown-header" v-show="s.m_num_issues > 0"><a :href="s.url" target="_blank">{{ s.name }}</a></li>
                <li v-for="issue in s.m_issues" class="pl-3 pr-1 text-grey-dark text-sm">
                    {{ issue.issue }}
                </li>
            </div>
            <li class="dropdown-header">Other issues</li>
            <li v-for="issue in overall_issues">
                <p class="pl-3 pr-1 text-sm text-grey-dark"> {{ issue.issue }}</p>
            </li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: "story_overall",
        props: {
            image: Object
        },
        computed: {
            story_issues() {
                return this.image.data.story_issues
            },
            overall_issues() {
                return this.image.data.overall_issues
            },
            severity() {
                let s_reducer = (acc, curr) => acc + curr.m_severity
                let o_reducer = (acc, curr) => acc + curr.severity
                return this.story_issues.reduce(s_reducer, 0) + this.overall_issues.reduce(o_reducer, 0)
            },
            num_issues() {
                let s_reducer = (acc, curr) => acc + curr.m_num_issues
                return this.story_issues.reduce(s_reducer, 0) + this.overall_issues.length
            },
            bg_color() {
                if (this.severity > 30) {
                    return 'bg-red-dark'
                } else if (this.severity > 0) {
                    return 'bg-grey-dark'
                } else {
                    return 'bg-green-dark'
                }
            }
        },
    }
</script>

<style scoped>

</style>