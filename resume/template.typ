#import "@preview/fontawesome:0.2.0": *

#let build_header(personal_infos, header_bg, use_full_address) = {
  let name_content = {
    set text(weight: "bold", size: 2em)
    smallcaps([#personal_infos.first_name\ #personal_infos.last_name])
  }

  let contact_content = grid(
    columns: (1.8em, auto, 1.8em, auto),
    align: (top + left, left + top, center + horizon, left + horizon),
    row-gutter: 0.3em,
    [#grid.cell(rowspan: 3)[#fa-icon("location-dot", solid: true)]],
    grid.cell(rowspan: 3)[
      #if use_full_address [
        #personal_infos.street_no #personal_infos.street\ 
      ]
      #personal_infos.city\ #personal_infos.country, #personal_infos.province, #personal_infos.postal_code
    ],
    [#fa-icon("square-phone-flip", solid: true)],
    [#personal_infos.phone],
    [#fa-icon("square-envelope", solid: true)],
    [#link("mailto:" + personal_infos.email, [#personal_infos.email])],
    [#fa-linkedin()],
    [#link("https://www.linkedin.com/in/" + personal_infos.linkedin_profile, [#personal_infos.linkedin_profile])]
  )

  let inner_content = grid(
    columns: (1fr, auto),
    [#align(left + bottom, name_content)],
    [#align(right + bottom, contact_content)]
  )

  rect(
    width: 100%,
    height: 100%,
    outset: (x: 100%),
    inset: 0pt,
    fill: header_bg,
    stroke: (bottom: 1pt + black),
    align(horizon, inner_content)
  )

}

#let label_box(content) = {
  set text(size: 0.7em, fill: white)
  move(dy: -3pt)[
    #rect(fill: black, stroke: none, radius: 5pt, inset: 3pt)[*#content*]
  ]
}

#let build_timeline(name, events) = {
  let cells = ()

  for e in events {
    cells.push([
      #grid.cell(inset: (right: 10pt))[#e.start - #e.end]
    ])
    cells.push([
      #let left_margin = 10pt
      #let bottom_margin = 1em
      #let circle_width = 0.7em
      #rect(
        width: 100%,
        stroke: (left: 1pt),
        inset: (left: left_margin, top: 0pt, bottom: bottom_margin),
      )[
        
        #rect(
          stroke: (bottom: 1pt + black, left: 1pt + black),
          fill: rgb("FFBE98"),
          radius: (top-right: 2pt),
          inset: (x: 0pt, y: 3pt),
          outset: (left: left_margin),
          width: 100%
        )[
          #set text(fill: black)
          == #e.title
          _ #e.organization.name, #e.organization.city, #e.organization.province _
        ]
        #place(top + left, dx: {-left_margin - circle_width/2}, dy: 0pt)[
          #circle(width: circle_width, fill: white, stroke: 1pt + black)
        ]
        #e.description
      ]
    ])
    if "specific_events" in e {
      for se in e.specific_events {
        cells.push(
          grid.cell(inset: (right: 10pt), align: horizon)[#label_box(se.year)]
        )
        cells.push(
          grid.cell(align: horizon)[
            #rect(
              width: 100%,
              stroke: (left: 1pt),
              inset: (left: 10pt, top: 0pt, bottom: 8pt)
            )[
              #se.name
            ]
          ]
        )
      }
    }
  }
  set par(justify: true)
  heading(name)
  grid(
    columns: (7em, auto),
    align: (right, left),
    ..cells
  )
}

#let build_skills_interest_content(categorized_data, header_bg, content_bg) = {
  for (cat, levels) in categorized_data.pairs() {
    block(breakable: false,
      stack(
        dir: ttb,
        rect(width: 100%, radius: (top: 5pt), fill: header_bg)[
          == #cat
        ],
        rect(width: 100%, radius: (bottom: 5pt), fill: content_bg, {
          if type(levels) != dictionary {
            levels
          } else {
            for (level_name, level_contents) in levels.pairs() {
              heading(level: 3, level_name)
              align(center)[#level_contents.join(" • ")]
              parbreak()
            }
          }
        })
      )
    )
  }
}

#let resume(
  personal_infos,
  work_experiences,
  education_experiences,
  skills,
  interests,
  use_full_address: false,
  header_bg: rgb("F6995C"),
  skill_interests_header_bg: rgb("FFBE98"),
  skill_interests_content_bg: rgb("FEECE2"),
) = {
  set text(font: "Noto Serif", size: 10pt)
  let header_content = build_header(personal_infos, header_bg, use_full_address)
  set page(header: header_content, header-ascent: 10%, margin: (top: 70pt, bottom: 30pt, x: 0.7cm),fill: white, numbering: "1 / 1")

  show heading.where(level: 1): h => {
    set text(size: 1.2em)
    rect(
      width: 100%,
      inset: (bottom: 0.3em, rest: 1pt),
      stroke: (bottom: 1pt + black),
      h.body
    )
  }
  show link: l => {
    set text(fill: rgb(13, 0 , 110))
    underline(l)
  }

  grid(
    columns: (7fr, 3fr),
    column-gutter: 1em,
    {
      build_timeline("Work Experience", work_experiences)
      build_timeline("Education", education_experiences)
    },
    grid.cell()[

      #show heading.where(level: 1): set align(center)
      #show heading.where(level: 2): h => {
        set align(center + horizon)
        block(h.body)
      }
      #show heading.where(level: 3): h => {
        set align(center + horizon)
        block(underline[#h.body])
      }

      = Skills
      #build_skills_interest_content(skills, skill_interests_header_bg, skill_interests_content_bg)
      = Interests
      #build_skills_interest_content(interests, skill_interests_header_bg, skill_interests_content_bg)
    ]
  )
}