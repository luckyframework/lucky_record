require "./spec_helper"

private class CallbacksForm < Post::BaseForm
  @callbacks_that_ran = [] of String
  getter callbacks_that_ran

  prepare do
    setup_required_fields
    mark_callback "prepare"
  end

  after_prepare do
    mark_callback "after_prepare"
  end

  before_save do
    mark_callback "before_save"
  end

  after_save do |post|
    mark_callback "after_save"
  end

  private def mark_callback(callback_name)
    callbacks_that_ran << callback_name
  end

  private def setup_required_fields
    title.value = "Title"
  end
end

describe "LuckyRecord::Form callbacks" do
  it "does not run the save callbacks if just validating" do
    form = CallbacksForm.new
    form.callbacks_that_ran.should eq([] of String)

    form.valid?
    form.callbacks_that_ran.should eq(["prepare", "after_prepare"])
  end

  it "runs all callbacks when saving" do
    form = CallbacksForm.new
    form.callbacks_that_ran.should eq([] of String)

    form.save

    form.callbacks_that_ran.should eq([
      "prepare",
      "after_prepare",
      "before_save",
      "after_save",
    ])
  end
end
