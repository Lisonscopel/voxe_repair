require 'test_helper'

class Api::V1::ElectionsControllerTest < ActionController::TestCase
  setup do
    sign_in FactoryGirl.create(:admin)

    @election = FactoryGirl.create(:election)

    @election.save!
  end

  test "should create an election" do
    assert_difference('Election.count') do
      post :create, election: FactoryGirl.attributes_for(:election), format: 'json'
    end

    json = JSON.parse @response.body
    assert_response :success
    assert json['response']["election"]["id"].present?
  end

  test "should show an election" do
    get :show, id: @election.id.to_s, published: 'all', format: 'json'

    assert_response :success
    json = JSON.parse @response.body
    assert_equal @election.name, json['response']['election']['name']

    assert_equal Array, json['response']['election']['candidacies'].class
    json['response']['election']['candidacies'].each do |json_candidacy|
      assert json_candidacy['id'].present?
      assert @election.candidacies.collect {|c| c.id.to_s}.include?(json_candidacy['id'])
    end

    assert_equal Array, json['response']['election']['tags'].class
    json['response']['election']['tags'].each do |json_tag|
      assert @election.root_election_tags.collect {|et| et.tag.name}.include?(json_tag['name'])
    end

  end

  test "should add a tag for an election" do
    @tag = FactoryGirl.create(:tag)
    post :addtag, id: @election.id.to_s, tagId: @tag.id.to_s, format: 'json'
    assert_response :success
    assert assigns(:election_tag).persisted?
    assert_equal @election.id.to_s, assigns(:election_tag).election.id.to_s
    assert_equal @tag.id.to_s, assigns(:election_tag).tag.id.to_s
  end

  test "should search some elections" do
    get :search, name: @election.name, format: 'json'
    # TODO Send params to search by year, country, current election, and parent election

    assert_response :success

    json = JSON.parse(@response.body)
    assert json['response']['elections'].present?
  end

  test "should add a candidacy" do
    candidate = FactoryGirl.create(:candidate)
    assert_difference("Candidacy.count") do
      post :addcandidacy, id: @election.id.to_s, candidateIds: candidate.id.to_s, format: 'json'
    end

    assert_response :success
  end

  test "should remove a tag on election" do
    tag = Tag.first
    election_tag = ElectionTag.create!(election: @election, tag: tag)

    assert @election.election_tags.where(tag_id: tag.id).present?
    delete :removetag, id: @election.id.to_s, tagId: tag.id.to_s, format: 'json'

    assert_response :success
    assert assigns(:election).election_tags.where(tag_id: tag.id).empty?
  end

  test "should add a contributor to an election" do
    user = FactoryGirl.create(:user)
    post :addcontributor, id: @election.id.to_s, userId: user.id.to_s, format: 'json'
    assert_response :success
    @election.reload
    assert_equal user.id, @election.contributors.last.id
  end

  test "should add an ambassador to an election" do
    user = FactoryGirl.create(:user)
    post :addambassador, id: @election.id.to_s, userId: user.id.to_s, format: 'json'
    assert_response :success
    @election.reload
    assert_equal user.id, @election.ambassadors.last.id
  end

  test "should have the list of contributors" do
    user = FactoryGirl.create(:user)
    @election.contributors << user
    @election.save
    get :contributors, id: @election.id.to_s, format: 'json'
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal user.id.to_s, json['response'].first['id']
  end

  test "should have the list of ambassadors" do
    user = FactoryGirl.create(:user)
    @election.ambassadors << user
    @election.save
    get :ambassadors, id: @election.id.to_s, format: 'json'
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal user.id.to_s, json['response'].first['id']
  end
end
