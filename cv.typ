#let generateAddress(
    author: (),
) = [
    *#author.firstName #author.lastName* \
    #author.address.street #author.address.houseNumber \
    #author.address.postalCode #author.address.city
]

#let generateDetails(author: ()) = [
    //#box(height: 8pt, image("../lib/icons/calendar.svg")) #author.birthday \
    #box(height: 8pt, image("./icons/at-sign.svg")) #author.email \
    #box(height: 8pt, image("./icons/phone.svg")) #author.phone \
    #link(author.socials.website.link)[#box(height: 8pt, image("./icons/globe.svg"))]
    #h(1mm)
    #link(author.socials.linkedin.link)[#box(height: 8pt, image("./icons/linkedin.svg"))]
    #h(1mm)
    #link(author.socials.github.link)[#box(height: 8pt, image("./icons/github.svg"))]
]

#let signOff(author: (), signature: none) = {
    v(1fr)

    [#author.address.city, den #datetime.today().display("[day]. [month repr:long] [year]")]

    linebreak()

    box(width: 5cm, image(signature))
}

#let timeline(type: none, items: [], accentColor: none) = {

    let lineColor = rgb("#d6d6d6")

    let firstColumnWidth = 32mm
    let columnGutter = 5mm
    let lineOverhang = 1mm

    let timeItems = ()

    show heading.where(level: 2): (it) => {
        text(weight: 700, size: 10pt, it.body)
    }

    show emph : it => {
        text(fill: accentColor, style: "italic", it.body)
    }

    if (type == "job") {

        for (index, item) in items.enumerate() {

            let timeSpan = align(right)[#item.start - #item.end]

            let content = [
                #heading(level: 2, item.company) #h(2mm) #box(height: 8pt, image("./icons/map-pin.svg")) #item.location \
                _ #item.role _ \
                #list(..item.tasks)
            ]

            timeItems.push(timeSpan)
            timeItems.push(content)
        }
        //repr(timeItems)
    }

    if (type == "education") {

        for (index, item) in items.enumerate() {

            let timeSpan = align(right)[#item.start - #item.end]

            let content = [
                #heading(level: 2, item.institution) #h(2mm) #box(height: 8pt, image("./icons/map-pin.svg")) #item.location \
                #eval(item.description, mode: "markup")
            ]

            timeItems.push(timeSpan)
            timeItems.push(content)
        }
        //repr(timeItems)
    }

    if (type == "descriptive") {
        
        for (index, item) in items.enumerate() {

            let content = [
                #heading(level: 2, item.item) \
                #list(marker: "-", ..item.tasks.map(i => {
                    //panic(i)
                    eval(i, mode: "markup")
                }))
            ]

            timeItems.push([])
            timeItems.push(content)
        }
        //repr(timeItems)
    }

    let g = grid(
        columns: (firstColumnWidth, 1fr),
        column-gutter: columnGutter,
        row-gutter: 4mm,
        ..timeItems
    )

    // Measure size of the grid depending on the layout constraints
    layout(size => style(styles => {
        let (width, height) = measure(block(width: size.width, g), styles)

        g
        place(dy: -height -lineOverhang, dx: firstColumnWidth + (0.5 * columnGutter),  line(angle: 90deg, stroke: (paint: lineColor, thickness: 0.4pt), length: height + 3 *lineOverhang))
    }))

}

#let skills(items: []) = {

    let lineColor = rgb("#d6d6d6")

    let firstColumnWidth = 32mm
    let columnGutter = 5mm
    let lineOverhang = 1mm

    show heading.where(level: 2): (it) => {
        align(right)[#text(size: 10pt, weight: 400, upper(it.body))]
    }

    let itemList = ()

    for (index, item) in items.enumerate() {

        let type = [#heading(level: 2, item.type)]

        let content = {
            item.items.map(i => {
                let parts = i.split("(")
                let head = parts.at(0)
                if parts.len() > 1 {
                    let foot = parts.slice(1, parts.len()).join("(")
                    [*#head* (#foot]
                } else {
                    [*#head*]
                }
            }).join("\n")
        }

        itemList.push(type)
        itemList.push(content)
    }

    let g = grid(
        columns: (firstColumnWidth, 1fr),
        column-gutter: columnGutter,
        row-gutter: 4mm,
        ..itemList
    )

    // Measure size of the grid depending on the layout constraints
    layout(size => style(styles => {
        let (width, height) = measure(block(width: size.width, g), styles)

        g
        place(dy: -height -lineOverhang, dx: firstColumnWidth + (0.5 * columnGutter),  line(angle: 90deg, stroke: (paint: lineColor, thickness: 0.4pt), length: height + 3 *lineOverhang))
    }))
}

#let hobbies(items: []) = {

    let lineColor = rgb("#d6d6d6")

    let firstColumnWidth = 32mm
    let columnGutter = 5mm
    let lineOverhang = 1mm

    show heading.where(level: 2): (it) => {
        text(size: 10pt, weight: 700, it.body)
    }

    let itemList = ()

    for (index, item) in items.enumerate() {

        let content = {
            [#heading(level: 2, item.type) #item.description]
        }

        itemList.push([])
        itemList.push(content)
    }

    let g = grid(
        columns: (firstColumnWidth, 1fr),
        column-gutter: columnGutter,
        row-gutter: 4mm,
        ..itemList
    )

    // Measure size of the grid depending on the layout constraints
    layout(size => style(styles => {
        let (width, height) = measure(block(width: size.width, g), styles)

        g
        place(dy: -height -lineOverhang, dx: firstColumnWidth + (0.5 * columnGutter),  line(angle: 90deg, stroke: (paint: lineColor, thickness: 0.4pt), length: height + 3 *lineOverhang))
    }))
}

#let cv(
    author: (),
    picture: none,
    font: "Dinish",
    accentColor: color.aqua,
    doc,
) = {
    
    set page(
        paper: "a4",
        margin: 2cm,
    )

    set text(
        font: font,
        size: 10pt,
        hyphenate: true,
    )

    // Set heading styles
    show heading.where(level: 1): (it) => {

        let boxWidth = 2.5mm
        let boxHeight = 7.4mm

        grid(
            columns: (boxWidth, 1fr),
            rows: (auto),
            gutter: boxWidth,
            
            [#align(horizon)[#box(width: boxWidth, height: boxHeight, fill: accentColor)]],
            [#align(horizon)[#upper(it.body)]],
            
        )
    }

    set list(marker: "-")

    /* Generate document */
    
    place(
        top + right,
        box(
            height: 4cm,
            radius: 2cm,
            clip: true,
            image(picture),
        )
    )

    grid(
        columns: (60mm, 1fr),
        generateAddress(author: author),
        generateDetails(author: author)
    )

    

    doc
}



