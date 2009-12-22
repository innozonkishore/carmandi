// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


// -------------------------
// Multiple File Upload
// -------------------------
// function MultiSelector(list_target, max) {
//   this.list_target = list_target;this.count = 0;this.id = 0;if( max ){this.max = max;} else {this.max = -1;};this.addElement = function( element ){if( element.tagName == 'INPUT' && element.type == 'file' ){element.name = 'attachment[file_' + (this.id++) + ']';element.multi_selector = this;element.onchange = function(){var new_element = document.createElement( 'input' );new_element.type = 'file';this.parentNode.insertBefore( new_element, this );this.multi_selector.addElement( new_element );this.multi_selector.addListRow( this );this.style.position = 'absolute';this.style.left = '-1000px';};if( this.max != -1 && this.count >= this.max ){element.disabled = true;};this.count++;this.current_element = element;} else {alert( 'Error: not a file input element' );};};this.addListRow = function( element ){var new_row = document.createElement('li');var new_row_button = document.createElement( 'a' );new_row_button.title = 'Remove This Image';new_row_button.href = '#';new_row_button.innerHTML = 'Remove';new_row.element = element;new_row_button.onclick= function(){this.parentNode.element.parentNode.removeChild( this.parentNode.element );this.parentNode.parentNode.removeChild( this.parentNode );this.parentNode.element.multi_selector.count--;this.parentNode.element.multi_selector.current_element.disabled = false;return false;};new_row.innerHTML = element.value.split('/')[element.value.split('/').length - 1];new_row.appendChild( new_row_button );this.list_target.appendChild( new_row );};
// }

a = 20;

function attach_new_file(){
    Element.insert('mtb10', {
        bottom: "<div id='new_file'><input id='first_file_element' class='smallTextbox' type='file' size='23' name='photos[]'> <a class='small grey underline' onclick='remove_file(this)' onmouseover='change_cursor()' onmouseout='change_cursor_again()''>Delete</a></div>"
    });
    a = a - 1;
    if (a <= 0) 
        document.getElementById("small grey underline1").hide();
}

function remove_file(input){
    input.parentNode.remove();
    a = a + 1;
    if (a >= 1) 
        document.getElementById("small grey underline1").show();
    if (a >= 21) {
        Element.insert('mtb10', {
            bottom: "<div id='new_file'><input id='first_file_element' class='smallTextbox' type='file' size='23' name='photos[]'> <a class='small grey underline' onclick='remove_file(this)' onmouseover='change_cursor()' onmouseout='change_cursor_again()''>Delete</a></div>"
        });
        a = a - 1;
    }
}

function change_cursor(){
    document.body.style.cursor = "pointer";
}

function change_cursor_again(){
    document.body.style.cursor = "default";
}

function select_price_range(min, max){
		if (min == max && max == 0) {
				document.getElementById('min_price').value = min;
				document.getElementById('max_price').value = 'infinity';
		}
    else if (min == max) {
        document.getElementById('min_price').value = min;
        document.getElementById('max_price').value = '';
    }
    else {
        document.getElementById('min_price').value = min;
        document.getElementById('max_price').value = max;
    }
}

function check_all_vehicle_makes(){
    vehicle_makes = document.getElementsByClassName("make_chechboxes");
    for (i = 0; i <= vehicle_makes.length - 1; i++) {
        vehicle_makes[i].checked = true;
    }
}

function check_all_vehicle_categories(){
    vehicle_categories = document.getElementsByClassName("category_checkboxes");
    for (i = 0; i <= vehicle_categories.length - 1; i++) {
        vehicle_categories[i].checked = true;
    }
}

function check_required_fields1(){
		submit_form = 1;
		if($('vehicle_model_year').value == "") {
			$('year_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('year_is_required').style.display = 'none';
		}
		if($('vehicle_vehicle_make_id').value == "") {
			$('make_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('make_is_required').style.display = 'none';
		}
		if($('vehicle_model').value == "") {
			$('model_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('model_is_required').style.display = 'none';
		}
		if($('vehicle_zipcode').value == "") {
			$('zipcode_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('zipcode_is_required').style.display = 'none';
		}
		return submit_form;
}

function check_required_fields2(){
		submit_form = 1;
		if($('vehicle_doors').value == "") {
			$('doors_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('doors_is_required').style.display = 'none';
		}
		if($('vehicle_engine_type').value == "") {
			$('engine_type_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('engine_type_is_required').style.display = 'none';
		}
		if($('vehicle_mileage').value == "") {
			$('mileage_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('mileage_is_required').style.display = 'none';
		}
		if($('vehicle_asking_price').value == "") {
			$('price_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('price_is_required').style.display = 'none';
		}
		return submit_form;
}

function check_required_fields3() {
		submit_form = 1;
		if($('payment_info_firstname').value == "") {
			$('firstname_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('firstname_is_required').style.display = 'none';
		}
		if($('payment_info_lastname').value == "") {
			$('lastname_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('lastname_is_required').style.display = 'none';
		}
		if($('payment_info_address').value == "") {
			$('address_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('address_is_required').style.display = 'none';
		}
		if($('payment_info_city').value == "") {
			$('city_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('city_is_required').style.display = 'none';
		}
		if($('payment_info_state').value == "") {
			$('state_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('state_is_required').style.display = 'none';
		}
		if($('payment_info_postal_code').value == "") {
			$('postal_code_is_required').style.display = 'block';
			submit_form = 0;
		}
		else {
			$('postal_code_is_required').style.display = 'none';
		}
		if($('login_email').value == "") {
			
			if($('user_phone_number').value == "") {
				$('phone_number_is_required').style.display = 'block';
				submit_form = 0;
			}
			else {
				$('phone_number_is_required').style.display = 'none';
			}
			if($('user_email').value == "") {
				$('email_is_required').style.display = 'block';
				submit_form = 0;
			}
			else {
				$('email_is_required').style.display = 'none';
			}
			if($('user_password').value == "") {
				$('password_is_required').style.display = 'block';
				submit_form = 0;
			}
			else {
				$('password_is_required').style.display = 'none';
			}
			if($('user_password_confirmation').value == "") {
				$('pass_confirm_is_required').style.display = 'block';
				submit_form = 0;
			}
			else {
				$('pass_confirm_is_required').style.display = 'none';
			}
			if($('user_firstname').value == "") {
				$('user_firstname_is_required').style.display = 'block';
				submit_form = 0;
			}
			else {
				$('user_firstname_is_required').style.display = 'none';
			}
			if($('user_lastname').value == "") {
				$('user_lastname_is_required').style.display = 'block';
				submit_form = 0;
			}
			else {
				$('user_lastname_is_required').style.display = 'none';
			}
			if($('user_zipcode').value == "") {
				$('zipcode_is_required').style.display = 'block';
				submit_form = 0;
			}
			else {
				$('zipcode_is_required').style.display = 'none';
			}
			
		}
		else {
			$('phone_number_is_required').style.display = 'none';
			$('email_is_required').style.display = 'none';
			$('password_is_required').style.display = 'none';
			$('pass_confirm_is_required').style.display = 'none';
			$('user_firstname_is_required').style.display = 'none';
			$('user_lastname_is_required').style.display = 'none';
			$('zipcode_is_required').style.display = 'none';
			
		}
		return submit_form;
}

function show_disclaimer() {
		$('vehicle_disclaimer').style.display = 'block';
}

function hide_disclaimer() {
		$('vehicle_disclaimer').style.display = 'none';
}

function show_coupon(coupon_id) {
		var coup_id = "coupon_image_" + coupon_id;
		$(coup_id).style.display = "block";
}

function hide_coupon(coupon_id) {
		var id = "coupon_image_" + coupon_id;
		$(id).style.display = "none";
}

function print_coupon(url) {
		// win = window.open(url, "Coupon");
		// win.focus();
		// setTimeout('win.print();', 1000);
		// setTimeout('win.close();', 2000);	
		// win.onload = function() { win.print(); };

	  		win = window.open();
	      self.focus();
	      win.document.open();
	      win.document.write('<' + 'html' + '><' + 'head' + '><' + 'style' + '>');
	      win.document.write('body, td { font-family: Verdana; font-size: 10pt;}');
	      win.document.write('<' + '/' + 'style' + '><' + '/' + 'head' + '><' + 'body' + '>');
	      win.document.write("<img src = '" + url+ "'>");
	      win.document.write('<' + '/' + 'body' + '><' + '/' + 'html' + '>');
	      win.document.close();
	      win.print();
	      win.close();	
	
		// if (win.attachEvent) {win.attachEvent('onload', function() { win.print(); });}
		// else if (win.addEventListener) {win.addEventListener('load', function() { win.print(); }, false);}
		// else {document.addEventListener('load', function() { win.print(); }, false);}
}

b = 98;

function attach_new_coupon(){
    Element.insert('mtb10', {
        bottom: "<div id='new_file'><div class='formFeild'><label>Coupon Name</label><input type='text' size='30' name='coupon_names[]' id='coupons__name'/></div><div class='formFeild'><label>Coupon Image</label> <input type='file' size='30' name='coupons[]' id='first_file_element'/></div></div>"
    });
    b = b - 1;
    if (b <= 0) 
        document.getElementById("small grey underline1").hide();
}


function submit_vehicle_form(){
    $('vehicle_form_submit_btn').disabled = true;
    $('vehicle_form_submit_btn').value = 'Please wait, uploading vehicle information';
    Element.show('vehicle_form_loading');
    
    if (swfu.getStats().files_queued < 1) {
        submit_form('vehicle_upload_form');
    }
    else {
        swfu.startUpload();
    }
    return false;
}

