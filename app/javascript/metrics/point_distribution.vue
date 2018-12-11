<template>
    <div>
        <div class="dropdown">
            <div v-show="scheduled.length > 0" class="float-left bg-grey-light text-grey-darkest" :style="{ width: 100 * scheduled.length / total.length + '%'}" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">{{ scheduled.length }}</div>

            <ul class="dropdown-menu">
                <li class="dropdown-header">Scheduled Stories</li>
                <li v-for="story in scheduled" :key="story.id" class="shadow">
                    <p class="px-3 mt-3 text-grey-darkest">{{ story.name }}</p>
                    <a class="text-grey" :href="story.url" target="_blank">Updated {{ days_ago(story) }} days ago</a>
                </li>
                <li><a :href="image.data.tracker_link" target="_blank"><span class="pin-l text-black px-5">Tracker</span></a></li>
            </ul>
        </div>
        <div class="dropdown">
            <div v-show="started.length > 0" class="float-left bg-blue-light text-grey-darkest" :style="{ width: 100 * started.length / total.length + '%' }" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">{{ started.length }}</div>
            <ul class="dropdown-menu">
                <li class="dropdown-header">Started Stories</li>
                <li v-for="story in started" :key="story.id" class="shadow">
                    <p class="px-3 mt-3 text-grey-darkest">{{ story.name }}</p>
                    <a class="text-grey" :href="story.url" target="_blank">Updated {{ days_ago(story) }} days ago</a>
                </li>
                <li><a :href="image.data.tracker_link" target="_blank"><span class="pin-l text-black px-5">Tracker</span></a></li>
            </ul>
        </div>
        <div class="dropdown">
            <div v-show="finished.length > 0" class="float-left bg-green-light text-grey-darkest" :style="{ width: 100 * finished.length / total.length + '%'}" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">{{ finished.length }}</div>
            <ul class="dropdown-menu">
                <li class="dropdown-header">Finished Stories</li>
                <li v-for="story in finished" :key="story.id" class="shadow">
                    <p class="px-3 mt-3 text-grey-darkest">{{ story.name }}</p>
                    <a class="text-grey" :href="story.url" target="_blank">Updated {{ days_ago(story) }} days ago</a>
                </li>
                <li><a :href="image.data.tracker_link" target="_blank"><span class="pin-l text-black px-5">Tracker</span></a></li>
            </ul>
        </div>
    </div>
</template>

<script>
    export default {
        name: "point_distribution",
        props: {
            i: String
        },
        computed: {
            image() {
                return JSON.parse(this.i)
            },
            scheduled() {
                return this.image['data']['unstarted'].concat(this.image['data']['planned'])
            },
            started() {
                return this.image['data']['started']
            },
            finished() {
                return this.image['data']['finished'].concat(this.image['data']['delivered'])
            },
            total() {
                return this.scheduled.concat(this.started).concat(this.finished)
            }
        },
        methods: {
            days_ago(story) {
                let d = new Date(story.updated_at)
                return Math.round((Date.now() -d) / (1000*60*60*24))

            }
        }
    }
</script>

<style scoped>
</style>