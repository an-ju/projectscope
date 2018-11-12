<template>
    <div class="dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" :class="ci_color" class="rounded-full h-full dropdown-toggle">
            <p class="text-white text-center w-full">{{ fail_since }}</p>
        </div>
        <ul class="dropdown-menu">
            <li><a :href="this.image.build_link" target="_blank">Latest build: {{ days_ago(this.build)}} days ago</a></li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: "travis_ci",
        props: {
            i: String,
        },
        computed: {
            image: function () {
                return JSON.parse(this.i)
            },
            builds: function () {
                return this.image.data.builds
            },
            build() {
                return this.builds[0]
            },
            ci_state: function () {
                return this.build.state
            },
            ci_color: function () {
                if (this.ci_state === 'passed') {
                    return 'bg-green-dark'
                } else {
                    return 'bg-red-dark'
                }
            },
            first_pass: function () {
                for (let i = 0; i !== this.builds.length; i++) {
                    if (this.builds[i].state === 'passed') {
                        return this.builds[i]
                    }
                }
                return false
            },
            fail_since: function () {
                if (this.ci_state === 'passed') {
                    return "Passed"
                } else {
                    let ps = this.first_pass
                    if (ps) {
                        return "Failed for " + this.days_ago(ps) + " days"
                    } else {
                        return "Failed over " + this.days_ago(ps) + " days"
                    }
                }
            },
        },
        methods: {
            days_ago(start_bd) {
                let d2 = new Date(start_bd.started_at)
                return Math.round((Date.now() -d2) / (1000*60*60*24))

            }
        }
    }
</script>

<style scoped>
    svg{
        height: 100%;
    }

</style>