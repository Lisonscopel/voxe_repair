$ ->
  formatOptionCandidate = (candidate) ->
    '<img src="https://voxe.s3.amazonaws.com/candidates/' + candidate.text.replace(/\s+/, "-") + '-50.jpg">&nbsp;' + candidate.text
  $("#candidacy_candidate_id").select2
    width: "250px"
    formatResult: formatOptionCandidate
    formatSelection: formatOptionCandidate
    escapeMarkup: (m) -> m
