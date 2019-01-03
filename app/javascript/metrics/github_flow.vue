<template>
    <div class="dropdown">
        <div :class="bg_color" class="text-white dropdown-toggle float-left px-3 rounded-full w-full" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
           {{ num_commits }} commits
        </div>
        <ul class="dropdown-menu">
            <li class="dropdown-header">New Commits</li>
            <li v-for="cmit in commits">
                <a class="px-3 text-grey-darker" :href="commit_link(cmit)" target="_blank">{{cmit.message }}</a>
            </li>
            <li role="separator" class="divider"></li>
            <li class="dropdown-header">New Branches</li>
            <li v-for="branch in branches" class="text-grey">
                <p class="px-3 text-center text-grey-darker">{{ branch.payload.ref }}</p>
            </li>
            <li role="separator" class="divider"></li>
            <li><a :href="image.data.network_link" target="_blank" class="text-grey-darker text-center px-3">Commit Network</a></li>
        </ul>
    </div>
    
</template>

<script>
    export default {
        name: "github_flow",
        props: {
            i: String,
        },
        computed: {
            image() {
                return JSON.parse(this.i)
            },
            pushes() {
                return this.image.data['pushes']
            },
            branches() {
                return this.image.data['branches']
            },
            bg_color() {
                if (this.pushes.length === 0) {
                    return 'bg-red-dark'
                } else {
                    return 'bg-green-dark'
                }
            },
            num_commits() {
                let reducer = (acc, curr) => acc + curr['payload']['distinct_size']
                return this.pushes.reduce(reducer, 0)
            },
            commits() {
                let reducer = (acc, curr) => acc.concat(curr['payload']['commits'])
                return this.pushes.reduce(reducer, []).slice(0, 5)
            }
        },
        methods: {
            commit_link(cmit) {
                return this.image.data.network_link.slice(0, -7) + 'commit/' + cmit.sha
            }
        }
    }
</script>

<style scoped>

</style>