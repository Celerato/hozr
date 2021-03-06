// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require tinymce-jquery
//= require select2
//= require jcrop
//= require_tree .

// Initialize behaviours
function initializeBehaviours() {
  // Init settings

  // from cyt.js
  addAutofocusBehaviour();
  addDatePickerBehaviour();
  addLinkifyContainersBehaviour();

  // from flash_message
  addFlashMessageBehaviour();

  // from directory_lookup.js
  addDirectoryLookupBehaviour();

  // from nested_form.js
  addNestedFormBehaviour();

  // select2
  setupSelect2();

  // application
  setupSlidepathLinks();
  setupRemarksModal();

  setupSubmitButtons();
  setupCancelButtons();
  setupPatientTableSelect();
  setupPatientMerging();

  setupPopOver();
//  setupBillingAddressToggle();

  setupPatientHistoryHover();
}

// Loads functions after DOM is ready
$(document).ready(initializeBehaviours);
