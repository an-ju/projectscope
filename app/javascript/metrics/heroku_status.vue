<template>
    <div class="w-full dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" :class="bar_color" class="text-white w-full dropdown-toggle rounded-full">
            {{ image['data']['web_status'] }}: {{ image['data']['web_response'] }}
        </div>
        <ul class="dropdown-menu">
            <li v-for="release in releases" :key="release.id">
                <a :href="release.output_stream_url" target="_blank" :class="status_color(release)">{{ days_ago(release) }} days ago</a>
            </li>
            <li role="separator" class="divider"></li>
            <li><a :href="image['data']['app_link']" target="_blank"><span class="pin-l text-black px-5">App</span></a></li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: "heroku_status",
        props: {
            image: Object
        },
        computed: {
            bar_color() {
                if (this.image['data']['web_status'] < 400) {
                    return 'bg-green-dark'
                } else {
                    return 'bg-red-dark'
                }
            },
            releases() {
                return this.image['data']['release']
            },
        },
        methods: {
            days_ago(release) {
                let d = new Date(release.updated_at)
                return Math.round((Date.now() - d) / (1000*60*60*24))
            },
            status_color(release) {
                switch(release.status) {
                    case 'failed':
                        return 'bg-red-lighter';
                    case 'succeeded':
                        return 'bg-green-lighter';
                    case 'pending':
                        return 'bg-yellow-lighter';
                }
            }
        }
    }
</script>

<style scoped>

</style>