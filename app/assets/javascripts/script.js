function uploadalert() {
    $("#micropost_picture").bind("change", function() {
        size_in_megabytes = this.files[0].size / 1024 / 1024;
        if (size_in_megabytes > 5) {
            alert("maximum size is 5mb");
        }
    })
}

$(document).ready(function() {
    uploadalert();
})
