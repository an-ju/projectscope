<template>
    <div class="dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" :style="{ width: bar_width }" :class="bar_color" class="float-left text-white dropdown-toggle">
            {{ 100 - this.maintainability['measure']['value'] }}
        </div>
        <ul class="dropdown-menu">
            <li class="px-3 py-3" v-for="(value, k, index) in measures" :key="index">{{ k }}: {{ value.value }}</li>
            <li><a :href="issue_link" target="_blank"><span class="pin-l text-black px-5">Issues</span><span class="pin-r badge">{{ issues }}</span></a></li>
        </ul>
    </div>
</template>
<script>
    export default {
        name: "code_climate",
        props: {
            image: Object,
        },
        computed: {
            maintainability: function () {
                let ratings = this.image['data']['ratings']
                return ratings.find(function (elem) {
                    return elem['pillar'] === 'Maintainability'
                })
            },
            bar_width: function () {
                return 100.0 - this.maintainability['measure']['value'] + '%'
            },
            bar_color: function () {
                switch(this.maintainability['letter']) {
                    case 'A':
                        return 'bg-green-dark'
                    case 'B':
                        return 'bg-yellow-dark'
                    case 'C':
                        return 'bg-orange-dark'
                    case 'D':
                        return 'bg-red-dark'
                }
            },
            issue_link: function () {
                return this.image['data']['issue_link']
            },
            measures: function () {
                return this.image['data']['meta']['measures']
            },
            issues: function () {
                return this.image['data']['meta']['issues_count']
            }
        },
    }
</script>

<style scoped>
</style>