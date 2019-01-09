<template>
    <div class="dropdown">
        <div v-show="standing.length + working.length > 0" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <div :style="{ width: standing_width() }" class="bg-green-light float-left text-grey-darkest">{{ standing.length }}</div>
            <div :style="{ width: working_width() }" class="bg-blue-light float-left text-grey-darkest">{{ working.length }}</div>
        </div>
        <div v-show="standing.length + working.length === 0" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <div class="bg-red-dark w-full float-left text-white px-3 rounded-full">No branch found</div>
        </div>
        <ul class="dropdown-menu">
            <li class="dropdown-header bg-green-light text-white">Branch being merged</li>
            <li v-for="br in standing">
                <span class="px-3 text-grey-dark">{{ br.name }}</span>
            </li>
            <li class="dropdown-header bg-blue-light text-white">Branch working</li>
            <li v-for="br in working">
                <span class="px-3 text-grey-dark">{{ br.name }}</span>
            </li>
            <li class="dropdown-header bg-grey text-white">Legacy branch</li>
            <li v-for="br in legacy">
                <span class="px-3 text-grey-dark">{{ br.name }}</span>
            </li>
        </ul>
   </div>
</template>

<script>
    export default {
        name: "github_branch",
        props: {
            image: Object
        },
        computed: {
            standing() {
                return this.image.data.standing_branches
            },
            working() {
                return this.image.data.working_branches
            },
            legacy() {
                return this.image.data.legacy_branches
            }
        },
        methods: {
            working_width() {
                return 100.0 * this.working.length / (this.working.length + this.standing.length) + '%'
            },
            standing_width() {
                return 100.0 * this.standing.length / (this.working.length + this.standing.length) + '%'
            }
        }
    }
</script>

<style scoped>

</style>