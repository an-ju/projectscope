<template>
    <div class="dropdown">
        <div class="w-1/2 px-1 float-left dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <div class="rounded-full w-full text-white" :class="bg_color(open_pr)"> {{ open_pr.length }}</div>
        </div>
        <div class="w-1/2 px-1 float-left dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <div class="rounded-full w-full text-white" :class="bg_color(closed_pr)"> {{ closed_pr.length }}</div>
        </div>
        <ul class="dropdown-menu">
            <li class="dropdown-header">Recently opened PR</li>
            <li v-for="pr in open_pr">
                <a :href="html_link(pr)" target="_blank">{{ pr_name(pr) }}</a>
            </li>
            <li role="separator" class="divider"></li>
            <li class="dropdown-header">Recently closed PR</li>
            <li v-for="pr in closed_pr">
                <a :href="html_link(pr)" target="_blank">{{ pr_name(pr) }}</a>
            </li>
            <li role="separator" class="divider"></li>
            <li>
                <a :href="image['data']['pr_link']" target="_blank">Pull Requests</a>
            </li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: "pull_requests",
        props: {
            i: String
        },
        computed: {
            image: function () {
                return JSON.parse(this.i)
            },
            open_pr() {
                return this.image['data']['new_pr']
            },
            closed_pr() {
                return this.image['data']['closed_pr']
            }
        },
        methods: {
            bg_color(pr_list) {
                if (pr_list.length > 0) {
                    return 'bg-green-dark'
                } else {
                    return 'bg-grey-dark'
                }
            },
            html_link(pr) {
                return pr['payload']['pull_request']['html_url']
            },
            pr_name(pr) {
                return pr['payload']['pull_request']['title']
            }
        }
    }
</script>

<style lang="scss" scoped>
.pr-uncommented {
    float: left;
    background-color: green;
}
.pr-commented {
    float: left;
    background-color: red;
}
</style>