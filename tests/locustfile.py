import base64

from locust import HttpUser, task
from random import randint, choice


class WebSockLoadTest(HttpUser):
    @task
    def load_test(self):
        usrPass = "user:password"
        encoded_u = base64.b64encode(usrPass.encode()).decode()
        #base64string = base64.encodestring('%s:%s' % ('user', 'password')).replace('\n', '')

        catalogue = self.client.get("/catalogue").json()
        category_item = choice(catalogue)
        item_id = category_item["id"]

        self.client.get("/")
        self.client.get("/login", headers={"Authorization":"Basic %s" % encoded_u})
        self.client.get("/category.html")
        self.client.get("/detail.html?id={}".format(item_id))
        self.client.delete("/cart")
        self.client.post("/cart", json={"id": item_id, "quantity": 1})
        self.client.get("/basket.html")
        self.client.post("/orders")