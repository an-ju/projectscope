<template>
    <div>
        <dropdown>
            <div slot="link" :style="{ width: bar_width }" :class="bar_color" class="cc-rating">{{ 100 - this.maintainability['measure']['value'] }}</div>
            <div slot="dropdown-items">
                <div class="bg-white rounded overflow-hidden">Test</div>
                <p>Another test</p>
            </div>
        </dropdown>
    </div>
</template>
<script>
    import Dropdown from '../components/dropdown'
    export default {
        name: "code_climate",
        props: {
            i: String,
        },
        computed: {
            null_data: function () {
                return this.d === 'null'
            },
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
            }
        },
        components: {
            'dropdown': Dropdown
        }
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