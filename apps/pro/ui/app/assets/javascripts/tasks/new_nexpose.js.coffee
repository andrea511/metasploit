jQuery ($) ->
  $(document).ready ->
    # Hide the optional Scan Credentials fields unless "Specify additional scan credentials" is checked
    $(document).on 'change', "#additional_creds_checkbox", ->
      $("#additional_creds_fields").toggle $("#additional_creds_checkbox").is(':checked')
    $("#additional_creds_checkbox").change()

    # Hide the optional pass the hash fields unless "Pass the CIFS/SMB hash credentials" is selected
    $(document).on 'change', "#nexpose_task_use_pass_the_hash_creds", ->
      $("#auto_pass_the_hash_fields").toggle $("#nexpose_task_use_pass_the_hash_creds").is(':checked')
    $("#nexpose_task_use_pass_the_hash_creds").change()

    # Enable the Custom Scan Template Name textfield when a "custom" Scan Template is selected
    setCustomScanTemplateEnablement = ->
      if $('#nexpose_task_scan_template').val() == "custom"
        $('#nexpose_task_custom_template').removeAttr "disabled"
      else
        $('#nexpose_task_custom_template').val() == ""
        $('#nexpose_task_custom_template').attr "disabled", "disabled"

    $(document).on 'change', '#nexpose_task_scan_template', ->
      setCustomScanTemplateEnablement()

    setCustomScanTemplateEnablement()
