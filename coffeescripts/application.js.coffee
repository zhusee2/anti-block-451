Array.prototype.shuffle = ->
  # Shuffle an Array with the Fisher Yates Algorithm from:
  # http://stackoverflow.com/questions/2450954/how-to-randomize-a-javascript-array
  suffleArray = (workingArray) ->
    i = workingArray.length
    return false if i is 0

    while --i
      j = Math.floor( Math.random() * (i + 1) )
      temp = workingArray[i]
      workingArray[i] = workingArray[j]
      workingArray[j] = temp

    return workingArray

  return suffleArray(@)

findElementsInViewport = ->
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

findLargestAreaElement = (elementsArray) ->
  getElementArea = (element) ->
    width = $(element).width()
    height = $(element).height()
    return width * height

  areasArray = []

  for index in [0...elementsArray.length]
    element = elementsArray[index]
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

init = ->
  priorAnimateElements = findElementsInViewport()
  largestElementResult = findLargestAreaElement(priorAnimateElements)
  blinkOutElement = largestElementResult.element
  priorAnimateElements.splice(largestElementResult.index, 1)

  $(blinkOutElement).addClass('blink-out')
  $(blinkOutElement).on 'animationend.anti-block webkitAnimationEnd.anti-block', ->
    shuffledElements = priorAnimateElements.shuffle()
    cumulatedDelay = 0
    for element in priorAnimateElements
      $(element).css('animation-delay', "#{cumulatedDelay}ms")
      $(element).addClass('fade-off')
      cumulatedDelay += 100

  return undefined


$ ->
  $('article').on 'click.anti-block', ->
    init()
    $('article').off 'click.anti-block'
