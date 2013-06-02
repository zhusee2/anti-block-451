window.findElementsInViewport = ->
  viewportBoundary = {
    top: window.scrollY
    right: window.scrollX + window.innerWidth
    bottom: window.scrollY + window.innerHeight
    left: window.scrollX
  }

  elementsInViewport = []

  $('article').each ->
    currentElement = @
    offset = $(currentElement).offset()
    withinHorizontal = (viewportBoundary.left < offset.left < viewportBoundary.right)
    withinVertical = (viewportBoundary.top < offset.top < viewportBoundary.bottom)

    elementsInViewport.push currentElement if withinHorizontal and withinVertical

  return elementsInViewport

window.findLargestAreaElement = (elementsArray) ->
  getElementArea = (element) ->
    width = $(element).width()
    height = $(element).height()
    return width * height

  areasArray = []

  for index, element of elementsArray
    areaIndicator = {index: index, area: getElementArea(element)}
    areasArray.push(areaIndicator)

  areasArray.sort (a,b) ->
    return -1 if a.area > b.area
    return 0 if a.area == b.area
    return 1 if a.area < b.area

  result = {
    index: areasArray[0].index
    element: elementsArray[areasArray[0].index]
  }

  return result

window.init = ->
  priorAnimateElements = findElementsInViewport()
  largestElementResult = findLargestAreaElement(priorAnimateElements)
  blinkOutElement = largestElementResult.element
  priorAnimateElements.splice(largestElementResult.index, 1)

  $(blinkOutElement).addClass('blink-out')
  $(blinkOutElement).on 'animationend.anti-block webkitAnimationEnd.anti-block', ->
    for element in priorAnimateElements
      delay = Math.random() * 1000
      $(element).css('animation-delay', "#{delay}ms")
      $(element).addClass('fade-off')

