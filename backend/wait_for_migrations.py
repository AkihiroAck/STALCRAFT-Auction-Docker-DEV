import time
import psycopg2
import os


def check_migrations_table():
    """Check if django_migrations table exists and has entries"""
    max_retries = 30
    retry_delay = 2

    for i in range(max_retries):
        try:
            conn = psycopg2.connect(
                dbname=os.getenv('POSTGRES_DATABASE_NAME'),
                user=os.getenv('POSTGRES_USERNAME'),
                password=os.getenv('POSTGRES_PASSWORD'),
                host=os.getenv('POSTGRES_HOST'),
                port=os.getenv('POSTGRES_PORT')
            )

            with conn.cursor() as cursor:
                # Check if django_migrations table exists
                cursor.execute("""
                    SELECT EXISTS (
                        SELECT FROM information_schema.tables 
                        WHERE table_name = 'django_migrations'
                    )
                """)
                table_exists = cursor.fetchone()[0]

                if table_exists:
                    # Check if there are any migrations applied
                    cursor.execute("SELECT COUNT(*) FROM django_migrations")
                    count = cursor.fetchone()[0]

                    if count > 0:
                        print("Migrations have been applied!")
                        conn.close()
                        return True

            conn.close()
            print(f"Waiting for migrations... (attempt {i + 1}/{max_retries})")

        except Exception as e:
            print(f"Error checking migrations: {e}")

        time.sleep(retry_delay)

    print("Migrations not completed after waiting")
    return False


if __name__ == "__main__":
    check_migrations_table()