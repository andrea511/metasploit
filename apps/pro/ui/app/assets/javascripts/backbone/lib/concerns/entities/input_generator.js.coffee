define [

], ->
  @Pro.module "Concerns", (Concerns,App,Backbone, Marionette, $, _) ->

    Concerns.InputGenerator =

      generateInputs: () ->
        $inputs = $('<form></form>')
        obj = @toJSON()
        prefix=""

        @recurseInputs($inputs,obj,prefix,true)
        $inputs

      recurseInputs: ($inputs, obj,prefix, firstTime) ->
        unless typeof obj == 'object'
          $inputs.append("<input name='#{prefix}' value='#{obj}' type='hidden'>")
        else
          #If an object or array iterate and recurse
          _.each(obj,(value,key,obj)=>
            prefixedKey = if firstTime then "#{key}" else "#{prefix}[#{key}]"
            if typeof value=='object'
              if Array.isArray(value)
                for elem, i in value
                  arrayPrefix = if firstTime then "#{key}[]" else "[#{key}][]"
                  @recurseInputs($inputs, elem, arrayPrefix,false)
              else
                @recurseInputs($inputs, value,prefixedKey,false)
            else
              $inputs.append("<input name='#{prefixedKey}' value='#{value}' type='hidden'>")
          )

