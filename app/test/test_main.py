import pytest
from unittest.mock import patch
from main import app
import datetime


@pytest.fixture
def client():
    with app.test_client() as client:
        yield client


class TestGetEndpoints:
    @patch("main.table")
    def test_missing_user(self, mock_table, client):
        mock_table.get_item.return_value = {}
        response = client.get("/hello/missinguser")
        assert response.status_code == 404

    @patch("main.table")
    def test_get_valid_user(self, mock_table, client):
        mock_table.get_item.return_value = {
            "Item": {"username": "alice", "dateOfBirth": "1985-05-20"}
        }
        response = client.get("/hello/alice")
        assert response.status_code == 200
        assert "message" in response.get_json()

    @patch("main.date")
    @patch("main.table")
    def test_get_valid_user_birthday_message(self, mock_table, mock_date, client):
        mock_date.today.return_value = datetime.date(2025, 5, 20)
        mock_date.fromisoformat = datetime.date.fromisoformat
        mock_table.get_item.return_value = {
            "Item": {"username": "alice", "dateOfBirth": "1985-05-20"}
        }
        response = client.get("/hello/alice")
        assert response.status_code == 200
        assert response.get_json()["message"] == "Hello, alice! Happy birthday!"

    @patch("main.date")
    @patch("main.table")
    def test_get_valid_user_birthday_in_x_days(self, mock_table, mock_date, client):
        mock_date.today.return_value = datetime.date(2025, 5, 10)
        mock_date.fromisoformat = datetime.date.fromisoformat
        mock_table.get_item.return_value = {
            "Item": {"username": "alice", "dateOfBirth": "1985-05-20"}
        }
        response = client.get("/hello/alice")
        assert response.status_code == 200
        assert (
            response.get_json()["message"]
            == "Hello, alice! Your birthday is in 10 day(s)"
        )


class TestPutEndpoints:
    @patch("main.table")
    def test_invalid_username(self, mock_table, client):
        response = client.put("/hello/user123", json={"dateOfBirth": "2000-01-01"})
        assert response.status_code == 400

    @patch("main.table")
    def test_invalid_date(self, mock_table, client):
        response = client.put("/hello/alice", json={"dateOfBirth": "3000-01-01"})
        assert response.status_code == 400

    @patch("main.table")
    def test_put_valid_user(self, mock_table, client):
        response = client.put("/hello/alice", json={"dateOfBirth": "1990-05-20"})
        assert response.status_code == 204
        mock_table.put_item.assert_called_once()


def test_health(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.data == b"OK"
