<template>
    <div class="dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="dropdown-toggle rounded-full w-full float-left text-white" :class="bg_color">{{ issues.length }} issues</div>
        <ul class="dropdown-menu">
            <li class="dropdown-header">Commit Issues</li>
            <li v-for="cmit in image.data.commit_issues">
                <p class="px-2 text-grey-dark text-base">{{ cmit.issue }}</p>
            </li>
            <li class="dropdown-header">Branch Issues</li>
            <li v-for="branch in image.data.branch_issues">
                <p class="px-2 text-grey-dark text-base">{{ branch.issue }}</p>
            </li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: "github_use",
        props: {
            image: Object
        },
        computed: {
            issues() {
                return this.image.data.branch_issues.concat(this.image.data.commit_issues)
            },
            severity() {
                let reducer = (acc, curr) => acc + curr['severity']
                return this.issues.reduce(reducer, 0)
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