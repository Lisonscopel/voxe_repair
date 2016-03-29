class window.MenuView extends Backbone.View
  
  render: ->
    view = new MenuCountryView(collection: @collection)
    $(@el).append view.render().el

    view = new MenuElectionView(model: @model)
    $(@el).append view.render().el
    
    view = new MenuCandidaciesView(model: @model)
    $(@el).append view.render().el
    
    view = new MenuTagsView(model: @model)
    $(@el).append view.render().el
    
    @