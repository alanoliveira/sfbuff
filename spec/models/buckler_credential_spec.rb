require 'rails_helper'

RSpec.describe BucklerCredential do
  let(:buckler_credential) { described_class.new }

  it "enqueues a RefreshBuildIdJob and RefreshAuthCookieJob after created" do
    expect { buckler_credential.save }
      .to have_enqueued_job(BucklerCredential::RefreshBuildIdJob)
        .and have_enqueued_job(BucklerCredential::RefreshAuthCookieJob)
  end

  describe "#ready?" do
    subject(:ready) { buckler_credential.ready? }

    context "when build_id and auth_cookie are present" do
      before { buckler_credential.assign_attributes(build_id: "foo", auth_cookie: "bar") }

      it { expect(ready).to be_truthy }
    end

    context "without build_id" do
      before { buckler_credential.assign_attributes(build_id: nil, auth_cookie: "bar") }

      it { expect(ready).to be_falsey }
    end

    context "without auth_cookie" do
      before { buckler_credential.assign_attributes(build_id: "foo", auth_cookie: nil) }

      it { expect(ready).to be_falsey }
    end
  end

  describe "#with_client" do
    context "when credentials is not ready" do
      before { allow(buckler_credential).to receive(:ready?).and_return(false) }

      it do
        expect { buckler_credential.with_client { } }.to raise_error(BucklerCredential::CredentialNotReady)
      end
    end

    context "when client throws a PageNotFound error" do
      before do
        allow(buckler_credential).to receive(:ready?).and_return(true)
        allow(buckler_credential).to receive(:expire_build_id!)
      end

      it do
        buckler_credential.with_client { raise BucklerApi::Errors::PageNotFound, spy }
      rescue BucklerApi::Errors::PageNotFound
        expect(buckler_credential).to have_received(:expire_build_id!)
      end
    end

    context "when client throws a Unauthorized error" do
      before do
        allow(buckler_credential).to receive(:ready?).and_return(true)
        allow(buckler_credential).to receive(:expire_auth_cookie!)
      end

      it do
        buckler_credential.with_client { raise BucklerApi::Errors::Unauthorized, spy }
      rescue BucklerApi::Errors::Unauthorized
        expect(buckler_credential).to have_received(:expire_auth_cookie!)
      end
    end
  end

  describe "#expire_auth_cookie!" do
    before { buckler_credential.tap { it.assign_attributes(build_id: "foo", auth_cookie: "bar") }.save }

    context "when auth_cookie is not empty on database" do
      it do
        expect { buckler_credential.expire_auth_cookie! }
          .to have_enqueued_job(BucklerCredential::RefreshAuthCookieJob)
      end
    end

    context "when auth_cookie is empty on database" do
      before { described_class.where(id: buckler_credential.id).update(auth_cookie: nil) }

      it do
        expect { buckler_credential.expire_auth_cookie! }
          .not_to have_enqueued_job(BucklerCredential::RefreshAuthCookieJob)
      end
    end
  end

  describe "#expire_build_id!" do
    before { buckler_credential.tap { it.assign_attributes(build_id: "foo", auth_cookie: "bar") }.save }

    context "when build_id is not empty on database" do
      it do
        expect { buckler_credential.expire_build_id! }
          .to have_enqueued_job(BucklerCredential::RefreshBuildIdJob)
      end
    end

    context "when build_id is empty on database" do
      before { described_class.where(id: buckler_credential.id).update(build_id: nil) }

      it do
        expect { buckler_credential.expire_build_id! }
          .not_to have_enqueued_job(BucklerCredential::RefreshBuildIdJob)
      end
    end
  end
end
