# DocPad Configuration File
# http://docpad.org/docs/config


marked = require 'marked'

# Define the DocPad Configuration
docpadConfig = {

    templateData:

        site:

            styles: [
                '/libs/shower-bright/styles/screen.css'
            ]

            scripts: [
                '/libs/shower-core/shower.min.js'
            ]
    plugins:

        marked:
            markedRenderer:
              html: (html)->
                  lines = html.trim().split('\n')
                  if (lines[0].indexOf('markdown="1"') != -1)
                      renderer = new marked.Renderer
                      openTag = lines.splice(0, 1)[0].replace(' markdown="1"', '')
                      closeTag = lines.splice(-1, 1)
                      console.log(lines.join('\n'));
                      return openTag + '\n' + marked(lines.join('\n')) + '\n' + closeTag + '\n'
                  else
                      return html

    collections:
        pages: (database)->
            @getCollection('documents').findAllLive({ extension: 'md' }).on 'add', (document)->
                a = document.attributes

                header = a.body.substring(0, a.body.indexOf('##'))
                body = a.body.substring(a.body.indexOf('##'))

                # Showerify header
                header = [
                    '<header class="caption" markdown="1"><div>\n'
                    header
                    '\n</div></header>'
                ].join('')

                # Showeriry slides
                paragraphs = body.split('##').filter (item)->
                    return item != ''

                showeryfied = paragraphs.join('\n</div></section><section class="slide" markdown="1"><div>\n##')
                showeryfied = '<section class="slide" markdown="1"><div>\n' + showeryfied + '\n</div></section>'

                document.attributes.body = header + showeryfied

}

# Export the DocPad Configuration
module.exports = docpadConfig
