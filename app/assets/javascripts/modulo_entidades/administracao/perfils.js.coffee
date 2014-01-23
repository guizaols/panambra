jQuery(($) ->
  initializeGlobalSelector = ($) ->
    $("[data-select=all]").on "click", (event) ->
      $a = $(event.currentTarget)
      $a.parents(".control-group").find("input[type=checkbox]").prop("checked", true)
    $("[data-select=none]").on "click", (event) ->
      $a = $(event.currentTarget)
      $a.parents(".control-group").find("input[type=checkbox]").prop("checked", false)

  initializeGroupedSystem = ($) ->
    $("[data-select=collection]").on "change click", (event) ->
      $checkbox = $(event.currentTarget)
      if $checkbox.find("input[type=checkbox]").is(":checked")
        $checkbox.parents(".controls").find("input[type=checkbox]").prop("checked", true)
      else
        $checkbox.parents(".controls").find("input[type=checkbox]").prop("checked", false)
    $("[data-select=member]").on "change click", (event) ->
      $checkbox = $(event.currentTarget)
      if $checkbox.parents(".controls").find("[data-select=member] input[type=checkbox]:not(:checked)").length > 0
        $checkbox.parents(".controls").find("[data-select=collection]").find("input[type=checkbox]").prop("checked", false)
      else
        $checkbox.parents(".controls").find("[data-select=collection]").find("input[type=checkbox]").prop("checked", true)

  initializeImportSystem = ($) ->
    $("#permissoes_baseado_em").on "change", (event) ->
      $select = $(event.currentTarget)
      if $select.val().length > 0
        $.ajax
          dataType: "json",
          success: (perfil) ->
            $.each perfil.permissoes, (controller, actions) ->
              $.each actions, (action, status) ->
                $("#perfil_permissoes_#{controller}_#{action}").prop("checked", status)
            $("[data-select=member]").change()
          url: "#{$select.data("source")}/#{$select.val()}"
      else
        $("[data-select=none]").click()

  initializeGlobalSelector($)
  initializeGroupedSystem($)
  initializeImportSystem($)

  $("[data-select=member]").change()
)
