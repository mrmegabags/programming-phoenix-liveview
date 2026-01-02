/***
 * Excerpted from "Programming Phoenix LiveView",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material,
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose.
 * Visit https://pragprog.com/titles/liveview for more book information.
***/
const plugin = require('tailwindcss/plugin')
const fs = require('fs')
const path = require('path')

module.exports = plugin(function ({ matchComponents, theme }) {
    let iconsDir = path.join(__dirname, "../../deps/heroicons/optimized")
    let values = {}
    let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"]
    ]
    icons.forEach(([suffix, dir]) => {
        if (fs.existsSync(path.join(iconsDir, dir))) {
            fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
                if (file.endsWith('.svg')) {
                    let name = path.basename(file, ".svg") + suffix
                    values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
                }
            })
        }
    })
    matchComponents({
        "hero": ({ name, fullPath }) => {
            let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "").replace("#", "%23")
            return {
                [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
                "-webkit-mask": `var(--hero-${name})`,
                "mask": `var(--hero-${name})`,
                "mask-repeat": "no-repeat",
                "background-color": "currentColor",
                "vertical-align": "middle",
                "display": "inline-block",
                "width": theme("spacing.5"),
                "height": theme("spacing.5")
            }
        }
    }, { values })
}) 