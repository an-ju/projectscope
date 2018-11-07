<template>
    <div class="dropdown">
        <div data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" :style="{ width: bar_width }" :class="bar_color" class="tc-rating dropdown-toggle">
            {{ this.report_attributes['covered_percent'] }}
        </div>
        <ul class="dropdown-menu">
            <li class="dropdown-header">Least Covered Files</li>
            <li v-for="(f, index) in least_covered_files" :key="'cov' + index">
                <span class="px-3 py-3">{{ f.attributes.path }}: {{ Math.round(f.attributes.covered_percent, 2) }}%</span>
            </li>
            <li role="separator" class="divider"></li>
            <li class="dropdown-header">Lowest Strength Files</li>
            <li v-for="(f, index) in lowest_strength_files" :key="'str' + index">
                <span class="px-3 py-3">{{ f.attributes.path }}: {{ Math.round(f.attributes.covered_strength, 2) }}</span>
            </li>
            <li role="separator" class="divider"></li>
            <li><a :href="coverage_link" target="_blank"><span class="pin-l text-black px-5">Report</span></a></li>
        </ul>
    </div>
</template>

<script>
    export default {
        name: "test_coverage",
        props: {
            d: String,
            s: String,
        },
        computed: {
            null_data: function () {
                return this.d === 'null'
            },
            image: function () {
                return JSON.parse(JSON.parse(this.d)['image'])
            },
            report_attributes: function () {
                return this.image['data']['report']['attributes']
            },
            bar_width: function () {
                return this.report_attributes['covered_percent'] + '%'
            },
            bar_color: function () {
                return 'tc-rating' + this.report_attributes['rating']['letter']
            },
            coverage_link: function () {
                return this.image['data']['coverage_link']
            },
            least_covered_files: function () {
                return this.image['data']['least_covered']
            },
            lowest_strength_files: function () {
                return this.image['data']['lowest_strength']
            }
        },
    }
</script>

<style scoped>
    .tc-rating {
        float: left
    }
    .tc-ratingA {
        background-color: green;
    }
    .tc-ratingB {
        background-color: yellowgreen;
    }
    .tc-ratingC {
        background-color: yellow;
    }
    .tc-ratingD {
        background-color: orange;
    }
</style>