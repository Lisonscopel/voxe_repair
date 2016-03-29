class Admin.Views.Election.Propositions.Tags.TagView extends Backbone.View
  tagName: 'tr'
  template: JST['admin/templates/election/propositions/tags/tag']

  initialize: ->
    @election = @options.election
    @candidacy = @options.candidacy
    @render()

  render: ->
    $(@el).html @template tag: @model.toJSON(), candidacy: @candidacy.toJSON(), election: @election.toJSON()

    @
