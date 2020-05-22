
class TestApp:
    def test_pass(self, client):
        resp = client.get("/ping")
        assert resp.status_code == 200
