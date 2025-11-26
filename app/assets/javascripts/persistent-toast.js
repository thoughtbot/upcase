Upcase.PersistentToast = class {
  static dismissedIdsLocalStorageKey = "persistent_toasts-dismissed_ids";

  static get all() {
    return [...document.getElementsByClassName("persistent-toast")]
      .map(element => new this(element));
  }

  static get dismissedIds() {
    return new Set(
      JSON.parse(
        localStorage.getItem(this.dismissedIdsLocalStorageKey)
      )
    );
  }

  static set dismissedIds(value) {
    localStorage.setItem(
      this.dismissedIdsLocalStorageKey,
      JSON.stringify(
        Array.from(value)
      )
    );
  }

  static addDismissedId(value) {
    if (!this.dismissedIds.has(value)) {
      this.dismissedIds = this.dismissedIds.add(value);
    }
  }

  static initializeAll() {
    this.all.forEach((persistentToast) => {
      persistentToast.initialize();
    });
  }

  constructor(element) {
    this.element = element;
    this.id = element.id;
  }

  get dismissButtonElements() {
    return this.element.getElementsByClassName("toast-button-dismiss");
  }

  initialize() {
    if (this.isDismissed()) {
      this.remove();
      return;
    }

    [...this.dismissButtonElements].forEach((dismissButtonElement) => {
      dismissButtonElement.addEventListener("click", () => {
        this.dismiss();
      });
    })
  }

  isDismissed() {
    return this.constructor.dismissedIds.has(this.id);
  }

  dismiss() {
    this.remove();
    this.constructor.addDismissedId(this.id);
  }

  remove() {
    this.element.remove();
  }
};

window.addEventListener("DOMContentLoaded", () => {
  Upcase.PersistentToast.initializeAll();
});
