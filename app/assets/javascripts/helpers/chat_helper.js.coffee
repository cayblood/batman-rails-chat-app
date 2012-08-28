Batman.mixin Batman.Filters,
  autolink: (text) ->
    return undefined if typeof text is 'undefined'
    # Turns all urls into clickable links.
    text.replace AUTO_LINK_RE, (href, scheme, offset) ->
      punctuation = []

      if isAutoLinked(text.slice(0, offset), text.slice(offset + href.length))
        # do not change string; URL is already linked
        href
      else
        linkText = href
        href = 'http://' + href unless scheme
        "<a href=\"#{href}\">#{linkText}</a>"

  prettyDate: (x) ->
    pad = (a, b) -> (1e15 + a + "").slice(-b)
    d = new Date(Date.parse(x))
    pad(d.getHours(), 2) + ":" + pad(d.getMinutes(), 2)

# regexps for determining context, used high-volume
AUTO_LINK_RE = ///
  (?: ([0-9A-Za-z+.:-]+:)// | www\. )
  [^\s<]+
///g
AUTO_LINK_CRE = [/<[^>]+$/, /^[^>]*>/, /<a\b.*?>/i, /<\/a>/i]
AUTO_EMAIL_RE = /[\w.!#\$%+-]+@[\w-]+(?:\.[\w-]+)+/

# Detects already linked context or position in the middle of a tag
isAutoLinked = (left, right) ->
  (AUTO_LINK_CRE[0].exec(left) and AUTO_LINK_CRE[1].exec(right)) or
    (AUTO_LINK_CRE[2].exec(left) and !AUTO_LINK_CRE[3].exec(right))
