"use strict"

angular.module('kg-mvc').directive 'kgDropdown', (kgDropdowns) ->
  restrict: 'A'
  scope:
    kgDropdown: '='
  link: (scope, element, attributes)->
    kgDropdowns.registerDropdown scope.kgDropdown, element


angular.module('kgapp').directive 'kgDropdownToggle', (kgDropdowns) ->
  restrict: 'A'
  scope:
    kgDropdownToggle: '='
  link: (scope, element, attributes)->
    kgDropdowns.registerToggle scope.kgDropdownToggle, element
    element.on "click", (e)->
      kgDropdowns.toggle scope.kgDropdownToggle, true
      e.stopPropagation()


angular.module('kgapp').factory 'kgDropdowns', ()->
  angular.element(window).on 'click', (event)->
    _.each dropdowns, (dropdown, dropdownName)->
      api.toggle(dropdownName, false)

  dropdowns = {}

  api =
    registerToggle: (dropdownName, element)->
      dropdowns[dropdownName] ?= {}
      _.extend dropdowns[dropdownName],
        toggle: element
        isOn: false

    registerDropdown: (dropdownName, element)->
      dropdowns[dropdownName] ?= {}
      _.extend dropdowns[dropdownName],
        dropdown: element
        displayValue: 'block'

    toggle: (dropdownName, value)->
      dropdowns[dropdownName]?.dropdown.css
        display: if value then dropdowns[dropdownName].displayValue else 'none'
      dropdowns[dropdownName]?.isOn = true
  api