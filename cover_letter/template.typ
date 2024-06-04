#import "@preview/fontawesome:0.2.0": *

#let build_personal_infos_content(personal_infos) = {
  set text(fill: luma(100), size: 1.0em)
  align(right)[
    *#personal_infos.first_name #personal_infos.last_name*\ 
    #personal_infos.street_no #personal_infos.street\ 
    #personal_infos.city\ 
    #personal_infos.province, #personal_infos.country, #personal_infos.postal_code\ 
    #fa-square-phone() #personal_infos.phone • #link("mailto:" + personal_infos.email, [#fa-square-envelope() #personal_infos.email])\ 
    #link("https://www.linkedin.com/in/" + personal_infos.linkedin_profile, [#fa-linkedin() #personal_infos.linkedin_profile]) • 
    #link("https://github.com/" + personal_infos.github_profile, [#fa-square-github() #personal_infos.github_profile]) • #link("https://bitbucket.org/" + personal_infos.bitbucket_profile,[#fa-square-gitlab() #personal_infos.bitbucket_profile])
  ]
}

#let build_letter_header_content(company_infos) = {
  let company_content = [
    *#company_infos.name*\ 
    #company_infos.street_no #company_infos.street\ 
    #company_infos.city\ 
    #company_infos.province, #company_infos.country, #company_infos.postal_code
  ]

  grid(
    columns: (1fr, 1fr),
    align: (left + top, top + right),
    company_content,
    datetime.today().display("[month repr:long] [day], [year]")
  )
}

#let build_closing_content(personal_infos, signature_img_path, closing, force_closing_bottom) = {
  let closing_aligment = left
  if force_closing_bottom {
    closing_aligment = closing_aligment + bottom
  }
  align(
    closing_aligment,
    box(
      width: 5cm,
      stack(
        dir: ttb,
        spacing: 4pt,
        closing,
        image(signature_img_path, width: 80%),
        rect(
          width: 100%,
          inset: (top: 5pt, rest: 0pt),
          stroke: (top: 1pt + black)
        )[
          *#personal_infos.first_name #personal_infos.last_name*
        ]
      )
    )
  )
}

#let cover_letter(
  personal_infos,
  company_infos,
  signature_img_path,
  opening,
  closing,
  body,
  font: "Noto Sans",
  force_closing_bottom: true
) = {
  set page(margin: 2.4cm)
  set text(font: font)

  build_personal_infos_content(personal_infos)

  block(
    above: 1.5em,
    build_letter_header_content(company_infos)
  )

  set par(justify: true)

  block(
    above: 2em,
    below: 2em,
    opening
  )
  
  body

  build_closing_content(personal_infos, signature_img_path, closing, force_closing_bottom)

}