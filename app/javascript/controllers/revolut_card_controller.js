import { Controller } from "@hotwired/stimulus";
import RevolutCheckout from "@revolut/checkout";

export default class extends Controller {
  static targets = ["cardForm", "card", "setupForm", "error"];
  static values = {
    publicId: String,
    mode: String,
  };

  initialize() {
    this.buildError.bind(this);
    this.cardFormListener = null;
    this.cardFieldDestroy = null;
  }

  connect() {
    RevolutCheckout(this.publicIdValue, this.modeValue).then((instance) => {
      this.cardFieldDestroy = () => instance.destroy();
      const self = this;
      const card = instance.createCardField({
        target: this.cardTarget,
        onSuccess() {
          console.log("createCardField onSuccess");
          self.buildError(null);
          self.setupFormTarget.submit();
        },
        onError(error) {
          console.log("createCardField onError", error);
          self.buildError(error);
          // this.setupFormTarget.submit()
        },
        onValidation(message) {
          console.log("createCardField onValidation", message);
        },
        onCancel() {
          console.log("createCardField onCancel");
        },
        locale: "en",
      });
      console.log("RevolutCheckout createCardField");

      this.cardFormListener = this.cardFormTarget.addEventListener(
        "submit",
        (event) => {
          // Prevent browser form submission. You need to submit card details first.
          event.preventDefault();
          this.buildError(null);
          console.log("RevolutCheckout submit", event);
          const data = new FormData(this.cardFormTarget);
          console.log("RevolutCheckout submit data", Object.fromEntries(data));
          card.submit({
            savePaymentMethodFor: "merchant",
            name: data.get("full_name"),
            email: data.get("email"),
            billingAddress: {
              countryCode: data.get("country"),
              region: data.get("state"),
              city: data.get("city"),
              streetLine1: data.get("line1"),
              streetLine2: data.get("line2"),
              postcode: data.get("postal"),
            },
          });
        }
      );
    });
  }

  buildError(error) {
    console.log("buildError", error);
    this.errorTarget.innerHTML = "";
    if (!error) return;

    console.log("buildError present");
    const errorContainer = document.createElement("DIV");
    errorContainer.classList.add("semantic-errors");
    const errorNode = document.createElement("DIV");
    errorNode.innerText = error.message;
    errorContainer.appendChild(errorNode);
    this.errorTarget.appendChild(errorContainer);
  }

  disconnect() {
    if (this.cardFormListener) {
      this.cardFormTarget.removeEventListener("submit", this.cardFormListener);
    }
    if (this.cardFieldDestroy) {
      this.cardFieldDestroy();
    }
  }
}
