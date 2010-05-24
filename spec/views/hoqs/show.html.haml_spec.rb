require "spec_helper"

describe "hoqs/show.html.haml" do

  before(:each) do
    assigns["qfd"] = stub_model(Qfd, :hoq_list => [])
  end

  context "first HOQ" do
    it "weights should indicate that they belong to the first HOQ" do
      list = stub_model(RequirementsList)
      pri_req = stub_model(Requirement, :requirements_list => list)
      hoq = stub_model(Hoq, 
                       :first? => true,
                       :primary_requirements => [pri_req,],
                       :secondary_requirements => [],
                       :name => "Test HOQ")
      assigns["hoq"] = hoq
      pri_req.stub(:primary_hoq).and_return(hoq)

      render

      response.should have_tag(".weight.first_hoq")
    end
  end

  context "non-first HOQ" do
    it "weights should not indicate that they belong to the first HOQ" do
      list = stub_model(RequirementsList)
      pri_req = stub_model(Requirement, :requirements_list => list)
      hoq = stub_model(Hoq, 
                       :primary_requirements => [pri_req,],
                       :secondary_requirements => [],
                       :name => "Test HOQ")
      assigns["hoq"] = hoq
      pri_req.stub(:primary_hoq).and_return(hoq)

      render

      response.should_not have_tag(".first_hoq")
    end
  end
end
