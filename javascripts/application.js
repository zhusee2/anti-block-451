(function() {
  var findElementsInViewport, findLargestAreaElement, init;

  Array.prototype.shuffle = function() {
    var suffleArray;
    suffleArray = function(workingArray) {
      var i, j, temp;
      i = workingArray.length;
      if (i === 0) {
        return false;
      }
      while (--i) {
        j = Math.floor(Math.random() * (i + 1));
        temp = workingArray[i];
        workingArray[i] = workingArray[j];
        workingArray[j] = temp;
      }
      return workingArray;
    };
    return suffleArray(this);
  };

  findElementsInViewport = function() {
    var elementsInViewport, viewportBoundary;
    viewportBoundary = {
      top: window.scrollY,
      right: window.scrollX + window.innerWidth,
      bottom: window.scrollY + window.innerHeight,
      left: window.scrollX
    };
    elementsInViewport = [];
    $('article').each(function() {
      var currentElement, offset, withinHorizontal, withinVertical, _ref, _ref1;
      currentElement = this;
      offset = $(currentElement).offset();
      withinHorizontal = (viewportBoundary.left < (_ref = offset.left) && _ref < viewportBoundary.right);
      withinVertical = (viewportBoundary.top < (_ref1 = offset.top) && _ref1 < viewportBoundary.bottom);
      if (withinHorizontal && withinVertical) {
        return elementsInViewport.push(currentElement);
      }
    });
    return elementsInViewport;
  };

  findLargestAreaElement = function(elementsArray) {
    var areaIndicator, areasArray, element, getElementArea, index, result, _i, _ref;
    getElementArea = function(element) {
      var height, width;
      width = $(element).width();
      height = $(element).height();
      return width * height;
    };
    areasArray = [];
    for (index = _i = 0, _ref = elementsArray.length; 0 <= _ref ? _i < _ref : _i > _ref; index = 0 <= _ref ? ++_i : --_i) {
      element = elementsArray[index];
      areaIndicator = {
        index: index,
        area: getElementArea(element)
      };
      areasArray.push(areaIndicator);
    }
    areasArray.sort(function(a, b) {
      if (a.area > b.area) {
        return -1;
      }
      if (a.area === b.area) {
        return 0;
      }
      if (a.area < b.area) {
        return 1;
      }
    });
    result = {
      index: areasArray[0].index,
      element: elementsArray[areasArray[0].index]
    };
    return result;
  };

  init = function() {
    var blinkOutElement, largestElementResult, priorAnimateElements;
    priorAnimateElements = findElementsInViewport();
    largestElementResult = findLargestAreaElement(priorAnimateElements);
    blinkOutElement = largestElementResult.element;
    priorAnimateElements.splice(largestElementResult.index, 1);
    $(blinkOutElement).addClass('blink-out');
    $(blinkOutElement).on('animationend.anti-block webkitAnimationEnd.anti-block', function() {
      var cumulatedDelay, element, shuffledElements, _i, _len, _results;
      shuffledElements = priorAnimateElements.shuffle();
      cumulatedDelay = 0;
      _results = [];
      for (_i = 0, _len = priorAnimateElements.length; _i < _len; _i++) {
        element = priorAnimateElements[_i];
        $(element).css('animation-delay', "" + cumulatedDelay + "ms");
        $(element).addClass('fade-off');
        _results.push(cumulatedDelay += 100);
      }
      return _results;
    });
    return void 0;
  };

  $(function() {
    return $('.btn-start-tour').on('click.anti-block', function(event) {
      init();
      $(this).off('.anti-block');
      $('.welcome-modal').addClass('hide');
      return event.preventDefault();
    });
  });

}).call(this);
