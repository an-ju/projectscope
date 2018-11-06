<template>
   <div class="relative">
       <div role="button" class="block select-none" @click.prevent="open = !open">
           <slot name="link"></slot>
       </div>
       <div v-show="open" class="absolute pin-b mt-px z-10">
           <slot name="dropdown-items"></slot>
       </div>
   </div>
</template>

<script>
    export default {
        name: "dropdown",
        data() {
            return {
                open: false
            }
        }
    }
</script>

<style scoped>

</style>