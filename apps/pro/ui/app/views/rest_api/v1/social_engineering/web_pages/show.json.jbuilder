json.partial! 'web_page', web_page: @web_page
json.content  @web_page.render_page_in_template
