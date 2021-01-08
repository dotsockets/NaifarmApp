class CarriersRespone {
	List<CarriersData> data;
	int total;

	CarriersRespone({this.data, this.total});

	CarriersRespone.fromJson(Map<String, dynamic> json) {
		if (json['data'] != null) {
			data = new List<CarriersData>();
			json['data'].forEach((v) {
				data.add(new CarriersData.fromJson(v));
			});
		}
		total = json['total'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
			data['data'] = this.data.map((v) => v.toJson()).toList();
		}
		data['total'] = this.total;
		return data;
	}
}

class CarriersData {
	int id;
	int shopId;
	int taxId;
	String name;
	String email;
	String phone;
	String trackingUrl;
	bool active;

	CarriersData(
			{this.id,
				this.shopId,
				this.taxId,
				this.name,
				this.email,
				this.phone,
				this.trackingUrl,this.active});

	CarriersData.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		shopId = json['shopId'];
		taxId = json['taxId'];
		name = json['name'];
		email = json['email'];
		phone = json['phone'];
		trackingUrl = json['trackingUrl'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = this.id;
		data['shopId'] = this.shopId;
		data['taxId'] = this.taxId;
		data['name'] = this.name;
		data['email'] = this.email;
		data['phone'] = this.phone;
		data['trackingUrl'] = this.trackingUrl;
		return data;
	}
}

