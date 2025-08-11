class WorkerChannel < ApplicationCable::Channel
  extend Turbo::Streams::StreamName
  include Turbo::Streams::StreamName::ClassMethods

  def subscribed
    return reject unless model.try(:subscribe!)

    stream_from model.to_gid_param
  end

  private

  def model
    GlobalID.find(verified_stream_name_from_params)
  end
end
