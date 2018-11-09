<template>
    <div class="dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" :style="{ width: bar_width }" :class="bar_color" class="cc-rating dropdown-toggle">
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
            i: String,
        },
        computed: {
            image: function () {
                return JSON.parse(this.i)
            },
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
                return 'cc-rating' + this.maintainability['letter']
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

<style lang="scss" scoped>
    .cc-rating {
        float: left
    }
    .cc-ratingA {
        background-color: green;
    }
    .cc-ratingB {
        background-color: yellowgreen;
    }
    .cc-ratingC {
        background-color: yellow;
    }
    .cc-ratingD {
        background-color: orange;
    }
</style>