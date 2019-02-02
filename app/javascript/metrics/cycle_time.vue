<template>
    <div class="dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" class="dropdown-toggle rounded-full w-full float-left text-white" :class="div_color()">
            Cycle Time: {{ cycle_time_display(metric.score) }}
        </div>
        <ul class="dropdown-menu">
            <li class="dropdown-header">Delivered Stories</li>
            <li v-for="story in image.data.all_stories">
                <div class="px-2" :class="text_color(story)">
                    <p>{{ story.name }}</p>
                    <p class="text-base">{{ cycle_time_display(story.cycle_time_details.total_cycle_time )}}</p>
                </div>
            </li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: "cycle_time",
        props: {
            image: Object,
            metric: Object
        },
        methods: {
            div_color() {
                if (this.metric.score < 2 * 24 * 3600 * 1000) {
                    return 'bg-green-dark'
                } else if (this.metric.score < 5 * 24 * 3600 * 1000) {
                    return 'bg-orange-dark'
                } else {
                    return 'bg-red-dark'
                }
            },
            cycle_time_display(t) {
                if (t < 24 * 3600 * 1000) {
                    return Math.round(t / (3600 * 1000)) + ' hour'
                } else {
                    return Math.round(t / (24 * 3600 * 1000)) + ' day'
                }
            },
            text_color(s) {
                if (s.current_state === 'accepted') {
                    return 'text-green-dark'
                } else {
                    return 'text-orange-dark'
                }
            }
        }
    }
</script>

<style scoped>

</style>